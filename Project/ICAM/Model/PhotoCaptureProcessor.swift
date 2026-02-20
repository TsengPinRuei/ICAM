//
//  PhotoCaptureProcessor.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import Photos

class PhotoCaptureProcessor: NSObject
{
    var photoData: Data?
    lazy var context=CIContext()
    
    private var maxPhotoProcessingTime: CMTime?
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    private let willCapturePhotoAnimation: () -> Void
    private let photoProcessingHandler: (Bool) -> Void
    private let completionHandler: (PhotoCaptureProcessor) -> Void
    
    init(
        with requestedPhotoSettings: AVCapturePhotoSettings,
        willCapturePhotoAnimation: @escaping () -> Void,
        completionHandler: @escaping (PhotoCaptureProcessor) -> Void,
        photoProcessingHandler: @escaping (Bool) -> Void
    )
    {
        self.requestedPhotoSettings=requestedPhotoSettings
        self.willCapturePhotoAnimation=willCapturePhotoAnimation
        self.completionHandler=completionHandler
        self.photoProcessingHandler=photoProcessingHandler
    }
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    {
        self.maxPhotoProcessingTime=resolvedSettings.photoProcessingTimeRange.start+resolvedSettings.photoProcessingTimeRange.duration
    }
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings)
    {
        DispatchQueue.main.async
        {
            self.willCapturePhotoAnimation()
        }
        
        guard let maxPhotoProcessingTime=self.maxPhotoProcessingTime
        else
        {
            return
        }
        
        let oneSecond=CMTime(seconds: 2, preferredTimescale: 1)
        if(maxPhotoProcessingTime > oneSecond)
        {
            DispatchQueue.main.async
            {
                self.photoProcessingHandler(true)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        DispatchQueue.main.async
        {
            self.photoProcessingHandler(false)
        }
        
        if let _=error {}
        else
        {
            self.photoData=photo.fileDataRepresentation()
        }
    }
    
    func saveToPhotoLibrary(_ photoData: Data)
    {
        PHPhotoLibrary.requestAuthorization
        {status in
            if(status == .authorized)
            {
                PHPhotoLibrary
                    .shared()
                    .performChanges(
                        {
                            let options=PHAssetResourceCreationOptions()
                            let creationRequest=PHAssetCreationRequest.forAsset()
                            options.uniformTypeIdentifier=self.requestedPhotoSettings.processedFileType.map { $0.rawValue }
                            creationRequest.addResource(with: .photo, data: photoData, options: options)
                        },
                        completionHandler:
                            {(_, _) in
                                DispatchQueue.main.async
                                {
                                    self.completionHandler(self)
                                }
                            }
                    )
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.completionHandler(self)
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?)
    {
        if let _=error
        {
            DispatchQueue.main.async
            {
                self.completionHandler(self)
            }
            
            return
        }
        else
        {
            guard let data=self.photoData
            else
            {
                DispatchQueue.main.async
                {
                    self.completionHandler(self)
                }
                
                return
            }
            
            self.saveToPhotoLibrary(data)
        }
    }
}
