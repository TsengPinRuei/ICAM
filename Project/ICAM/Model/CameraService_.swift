//
//  CameraService.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import Photos
import UIKit

public class CameraService
{
    typealias PhotoCaptureSessionID=String
    
    @Published public var flashMode: AVCaptureDevice.FlashMode = .off
    @Published public var shouldShowAlertView=false
    @Published public var shouldShowSpinner=false
    @Published public var willCapturePhoto=false
    @Published public var isCameraButtonDisabled=true
    @Published public var isCameraUnavailable=true
    @Published public var photo: Photo?
    
    public var alertError: AlertError=AlertError()
    public let session=AVCaptureSession()
    var isSessionRunning=false
    var isConfigured=false
    var setupResult: SessionSetupResult = .success
    private let sessionQueue=DispatchQueue(label: "session queue")
    
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    private let videoDeviceDiscoverySession =
    AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
        mediaType: .video,
        position: .unspecified
    )
    private let photoOutput=AVCapturePhotoOutput()
    private var inProgressPhotoCaptureDelegates=[Int64: PhotoCaptureProcessor]()
    private var keyValueObservations=[NSKeyValueObservation]()
    
    //MARK: 設置
    public func configure()
    {
        self.sessionQueue.async
        {
            self.configureSession()
        }
    }
    
    //MARK: 檢查權限
    public func checkForPermissions()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video)
        {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video)
            {granted in
                if(!granted)
                {
                    self.setupResult = .notAuthorized
                }
                
                self.sessionQueue.resume()
            }
        default:
            self.setupResult = .notAuthorized
            DispatchQueue.main.async
            {
                self.alertError =
                AlertError(
                    title: "相機權限錯誤",
                    message: "你沒有開啟相機權限喔",
                    primaryButtonTitle: "設定",
                    secondaryButtonTitle: nil,
                    primaryAction: {
                        UIApplication
                            .shared
                            .open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) {_ in}
                        
                    },
                    secondaryAction: nil
                )
                
                self.shouldShowAlertView=true
                self.isCameraUnavailable=true
                self.isCameraButtonDisabled=true
            }
        }
    }
    
    //MARK: 設置管理
    private func configureSession()
    {
        if(self.setupResult != .success)
        {
            return
        }
        
        self.session.beginConfiguration()
        self.session.sessionPreset = .photo
        do
        {
            var defaultVideoDevice: AVCaptureDevice?
            
            if let backCameraDevice=AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            {
                defaultVideoDevice=backCameraDevice
            }
            else if let frontCameraDevice=AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            {
                defaultVideoDevice=frontCameraDevice
            }
            
            guard let videoDevice=defaultVideoDevice
            else
            {
                self.setupResult = .configurationFailed
                self.session.commitConfiguration()
                return
            }
            
            let videoDeviceInput=try AVCaptureDeviceInput(device: videoDevice)
            
            if(self.session.canAddInput(videoDeviceInput))
            {
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput=videoDeviceInput
                
            }
            else
            {
                self.setupResult = .configurationFailed
                self.session.commitConfiguration()
                return
            }
        }
        catch
        {
            self.setupResult = .configurationFailed
            self.session.commitConfiguration()
            return
        }
        
        if(self.session.canAddOutput(self.photoOutput))
        {
            self.session.addOutput(self.photoOutput)
            self.photoOutput.isHighResolutionCaptureEnabled=true
            self.photoOutput.maxPhotoQualityPrioritization = .quality
            
        }
        else
        {
            self.setupResult = .configurationFailed
            self.session.commitConfiguration()
            return
        }
        
        self.session.commitConfiguration()
        self.isConfigured=true
        self.start()
    }
    
    //MARK: 更換相機
    public func changeCamera()
    {
        DispatchQueue.main.async
        {
            self.isCameraButtonDisabled=true
        }
        
        self.sessionQueue.async
        {
            let preferredPosition: AVCaptureDevice.Position
            let preferredDeviceType: AVCaptureDevice.DeviceType
            let currentVideoDevice=self.videoDeviceInput.device
            let currentPosition=currentVideoDevice.position
            
            switch(currentPosition)
            {
            case .unspecified, .front:
                preferredPosition = .back
                preferredDeviceType = .builtInWideAngleCamera
            case .back:
                preferredPosition = .front
                preferredDeviceType = .builtInWideAngleCamera
            @unknown default:
                preferredPosition = .back
                preferredDeviceType = .builtInWideAngleCamera
            }
            
            let devices=self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice?=nil
            
            if let device=devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType })
            {
                newVideoDevice=device
            }
            else if let device=devices.first(where: { $0.position == preferredPosition })
            {
                newVideoDevice=device
            }
            
            if let videoDevice=newVideoDevice
            {
                do
                {
                    let videoDeviceInput=try AVCaptureDeviceInput(device: videoDevice)
                    
                    self.session.beginConfiguration()
                    self.session.removeInput(self.videoDeviceInput)
                    
                    if self.session.canAddInput(videoDeviceInput)
                    {
                        self.session.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    }
                    else
                    {
                        self.session.addInput(self.videoDeviceInput)
                    }
                    
                    if let connection=self.photoOutput.connection(with: .video)
                    {
                        if(connection.isVideoStabilizationSupported)
                        {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                    
                    self.photoOutput.maxPhotoQualityPrioritization = .quality
                    self.session.commitConfiguration()
                }
                catch {}
            }
            
            DispatchQueue.main.async
            {
                self.isCameraButtonDisabled=false
            }
        }
    }
    
    //MARK: focus
    public func focus(at focusPoint: CGPoint)
    {
        let device=self.videoDeviceInput.device
        
        do
        {
            try device.lockForConfiguration()
            if(device.isFocusPointOfInterestSupported)
            {
                device.focusPointOfInterest=focusPoint
                device.exposurePointOfInterest=focusPoint
                device.exposureMode = .continuousAutoExposure
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            }
        }
        catch {}
    }
    
    //MARK: 停止擷取
    public func stop(completion: (() -> ())?=nil)
    {
        self.sessionQueue.async
        {
            if(self.isSessionRunning)
            {
                if(self.setupResult == .success)
                {
                    self.session.stopRunning()
                    self.isSessionRunning=self.session.isRunning
                    if(!self.session.isRunning)
                    {
                        DispatchQueue.main.async
                        {
                            self.isCameraButtonDisabled=true
                            self.isCameraUnavailable=true
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: 開始拍照
    public func start()
    {
        self.sessionQueue.async
        {
            if(!self.isSessionRunning && self.isConfigured)
            {
                switch(self.setupResult)
                {
                    case .success:
                        self.session.startRunning()
                        self.isSessionRunning=self.session.isRunning
                        
                        if(self.session.isRunning)
                        {
                            DispatchQueue.main.async
                            {
                                self.isCameraButtonDisabled=false
                                self.isCameraUnavailable=false
                            }
                        }
                    case .configurationFailed, .notAuthorized:
                        DispatchQueue.main.async
                        {
                            self.alertError =
                            AlertError(
                                title: "相機錯誤",
                                message: "你的相機無法運作或是沒有提供相機權限",
                                primaryButtonTitle: "接受",
                                secondaryButtonTitle: nil,
                                primaryAction: nil,
                                secondaryAction: nil
                            )
                            self.shouldShowAlertView=true
                            self.isCameraButtonDisabled=true
                            self.isCameraUnavailable=true
                    }
                }
            }
        }
    }
    
    //MARK: 設定
    public func set(zoom: CGFloat)
    {
        let factor=zoom<1 ? 1:zoom
        let device=self.videoDeviceInput.device
        
        do
        {
            try device.lockForConfiguration()
            device.videoZoomFactor=factor
            device.unlockForConfiguration()
        }
        catch {}
    }
    
    //MARK: 拍照
    public func capturePhoto()
    {
        if(self.setupResult != .configurationFailed)
        {
            self.isCameraButtonDisabled=true
            
            self.sessionQueue.async
            {
                var photoSettings=AVCapturePhotoSettings()
                
                if let photoOutputConnection=self.photoOutput.connection(with: .video)
                {
                    photoOutputConnection.videoOrientation = .portrait
                }
                
                if(self.photoOutput.availablePhotoCodecTypes.contains(.hevc))
                {
                    photoSettings=AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
                }
                if(self.videoDeviceInput.device.isFlashAvailable)
                {
                    photoSettings.flashMode=self.flashMode
                }
                
                photoSettings.isHighResolutionPhotoEnabled=true
                
                if(!photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty)
                {
                    photoSettings.previewPhotoFormat =
                    [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
                }
                
                photoSettings.photoQualityPrioritization = .quality
                
                let photoCaptureProcessor=PhotoCaptureProcessor(
                    with: photoSettings,
                    willCapturePhotoAnimation:
                        {[weak self] in
                            DispatchQueue.main.async
                            {
                                self?.willCapturePhoto=true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.25)
                            {
                                self?.willCapturePhoto=false
                            }
                            
                        },
                    completionHandler:
                        {[weak self] (photoCaptureProcessor) in
                            if let data=photoCaptureProcessor.photoData
                            {
                                self?.photo=Photo(originalData: data)
                            }
                            else {}
                            
                            self?.isCameraButtonDisabled=false
                            self?.sessionQueue.async
                            {
                                self?.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = nil
                            }
                        },
                    photoProcessingHandler:
                        {[weak self] animate in
                            if(animate)
                            {
                                self?.shouldShowSpinner=true
                            }
                            else
                            {
                                self?.shouldShowSpinner=false
                            }
                        })
                self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID]=photoCaptureProcessor
                self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
            }
        }
    }
}
