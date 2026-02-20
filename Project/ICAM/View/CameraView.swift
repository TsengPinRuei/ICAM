//
//  CameraView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import SwiftUI
import AVFoundation
import Combine

struct CameraView: View
{
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var camera=Camera()
    
    @State var currentZoomFactor: CGFloat=1
    
    //MARK: 拍照按鈕
    @ViewBuilder
    var captureButton: some View
    {
        Button
        {
            self.camera.capturePhoto()
        }
        label:
        {
            Circle()
                .foregroundStyle(.white)
                .frame(height: 80)
                .overlay(Circle().fill(.white).frame(height: 60).overlay(Circle().stroke(Color(red: 125/255, green: 190/255, blue: 255/255), lineWidth: 5)))
        }
    }
    //MARK: 相簿按鈕
    @ViewBuilder
    var photoButton: some View
    {
        Button
        {
            UIApplication.shared.open(URL(string: "photos-redirect://")!)
        }
        label:
        {
            Image(uiImage: self.camera.photo==nil ? UIImage():self.camera.photo.image!)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black))
                .animation(.easeInOut, value: self.camera.photo)
        }
    }
    //MARK: 相機頭按鈕
    @ViewBuilder
    var flipButton: some View
    {
        Button
        {
            self.camera.flipCamera()
        }
        label:
        {
            Image(systemName: "camera.rotate.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .foregroundStyle(.black)
        }
    }
    
    var body: some View
    {
        GeometryReader
        {reader in
            ZStack
            {
                //MARK: 背景顏色
                GradientBackColor()
                
                VStack(spacing: 30)
                {
                    //MARK: CameraPreview
                    CameraPreview(session: self.camera.session)
                        .gesture(
                            DragGesture()
                                .onChanged
                                {value in
                                    if abs(value.translation.height)>abs(value.translation.width)
                                    {
                                        let percentage: CGFloat = -(value.translation.height/reader.size.height)
                                        let calc=self.currentZoomFactor+percentage
                                        let zoomFactor: CGFloat=min(max(calc, 1), 5)
                                        self.currentZoomFactor=zoomFactor
                                        self.camera.zoom(with: zoomFactor)
                                    }
                                }
                        )
                        //MARK: 拍照
                        .overlay
                        {
                            if(self.camera.willCapturePhoto)
                            {
                                Color.black
                                    .padding(.vertical, 30)
                                    .transition(.opacity.animation(.easeInOut))
                            }
                        }
                        //MARK: 啟動相機
                        .onAppear
                        {
                            self.camera.configure()
                        }
                        .alert(isPresented: self.$camera.showAlertError)
                        {
                            Alert(
                                title: Text(self.camera.alertError.title),
                                message: Text(self.camera.alertError.message),
                                dismissButton: .default(
                                    Text(self.camera.alertError.primaryButtonTitle),
                                    action: { self.camera.alertError.primaryAction?() }
                                )
                            )
                        }
                    
                    HStack
                    {
                        //MARK: 相簿按鈕
                        self.photoButton
                        
                        Spacer()
                        
                        //MARK: 拍照按鈕
                        self.captureButton
                        
                        Spacer()
                        
                        //MARK: 翻轉按鈕
                        self.flipButton
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("相機")
        .toolbarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar
        {
            //MARK: Dismiss
            ToolbarItem(placement: .cancellationAction)
            {
                Button
                {
                    self.dismiss()
                }
                label:
                {
                    HStack(spacing: 0)
                    {
                        Image(systemName: "chevron.left").bold()
                        
                        Text("ＩＣＡＭ")
                    }
                    .font(.body)
                }
            }
            
            //MARK: 閃光燈
            ToolbarItem(placement: .topBarTrailing)
            {
                Button
                {
                    self.camera.switchFlash()
                }
                label:
                {
                    Image(systemName: self.camera.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                }
                .tint(self.camera.isFlashOn ? .yellow : .black)
            }
        }
    }
}
