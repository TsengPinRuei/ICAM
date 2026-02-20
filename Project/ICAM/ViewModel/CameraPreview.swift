//
//  CameraPreview.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable
{
    class VideoPreviewView: UIView
    {
        override class var layerClass: AnyClass
        {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer
        {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView
    {
        let view=VideoPreviewView()
        view.backgroundColor=UIColor.clear
        view.videoPreviewLayer.cornerRadius=0
        view.videoPreviewLayer.session=self.session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait

        return view
    }
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}
}
