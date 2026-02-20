//
//  Camera.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import AVFoundation
import Combine

final class Camera: ObservableObject
{
    @Published var isFlashOn=false
    @Published var showAlertError=false
    @Published var willCapturePhoto=false
    @Published var photo: Photo!
    
    var alertError: AlertError!
    var session: AVCaptureSession
    
    private let service=CameraService()
    private var subscriptions=Set<AnyCancellable>()
    
    //MARK: init
    init()
    {
        self.session=self.service.session
        
        self.service.$photo.sink
        {[weak self] (photo) in
            guard let pic=photo else
            {
                return
            }
            self?.photo=pic
        }
        .store(in: &self.subscriptions)
        
        self.service.$shouldShowAlertView.sink
        {[weak self] (val) in
            self?.alertError=self?.service.alertError
            self?.showAlertError=val
        }
        .store(in: &self.subscriptions)
        
        self.service.$flashMode.sink
        {[weak self] (mode) in
            self?.isFlashOn=mode == .on
        }
        .store(in: &self.subscriptions)
        
        self.service.$willCapturePhoto.sink
        {[weak self] (val) in
            self?.willCapturePhoto=val
        }
        .store(in: &self.subscriptions)
    }
    
    //MARK: 拍照
    func capturePhoto()
    {
        self.service.capturePhoto()
    }
    //MARK: 設置
    func configure()
    {
        self.service.checkForPermissions()
        self.service.configure()
    }
    //MARK: 翻轉相機
    func flipCamera()
    {
        self.service.changeCamera()
    }
    //MARK: 閃光燈
    func switchFlash()
    {
        self.service.flashMode=self.service.flashMode == .on ? .off : .on
    }
    //MARK: 放大縮小
    func zoom(with factor: CGFloat)
    {
        self.service.set(zoom: factor)
    }
}
