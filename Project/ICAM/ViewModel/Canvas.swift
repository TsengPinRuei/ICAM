//
//  Canvas.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI

class Canvas: NSObject, ObservableObject
{
    @Published var stack: [StackItem]=[]
    @Published var showEditPicker: Bool=false
    @Published var imageData: Data = Data(count: 0)
    @Published var showError: Bool=false
    @Published var errorMessage: String=""
    @Published var current: StackItem?
    @Published var showDelete: Bool=false
    
    func addImage(image: UIImage)
    {
        let image: some View =
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
        
        //self.stack.append(StackItem(view: AnyView(image)))
        self.stack.insert(StackItem(view: AnyView(image)), at: self.stack.count-1)
    }
    func safeArea() -> UIEdgeInsets
    {
        guard let screen=UIApplication.shared.connectedScenes.first as? UIWindowScene else
        {
            return .zero
        }
        guard let safeArea=screen.windows.first?.safeAreaInsets else
        {
            return .zero
        }
        
        return safeArea
    }
    func saveImage<Content: View>(height: CGFloat, @ViewBuilder content: @escaping () -> Content) -> UIImage?
    {
        let uiView: UIHostingController=UIHostingController(rootView: content().padding(.top, -safeArea().top))
        //CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: height))
        let frame: CGRect=CGRect(origin: .zero, size: CGSize(width: 512, height: 512))
        
        uiView.view.frame=frame
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        uiView.view.drawHierarchy(in: frame, afterScreenUpdates: true)
        
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let result=result
        {
            self.writeAlbum(image: result)
        }
        
        return result
    }
    @objc
    func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
    {
        if let error=error
        {
            self.errorMessage=error.localizedDescription
            self.showError.toggle()
        }
        else
        {
            self.errorMessage="儲存成功！"
            self.showError.toggle()
        }
    }
    @objc
    func writeAlbum(image: UIImage)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(_: didFinishSavingWithError: contextInfo:)), nil)
    }
}
