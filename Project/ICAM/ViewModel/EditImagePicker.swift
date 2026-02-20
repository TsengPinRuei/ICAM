//
//  ImagePickerView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI
import PhotosUI

struct EditImagePicker: UIViewControllerRepresentable
{
    @Binding var showPicker: Bool
    @Binding var imageData: Data
    var quality: CGFloat=1
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController
    {
        var configuration: PHPickerConfiguration=PHPickerConfiguration()
        configuration.selectionLimit=1
        
        let controller: PHPickerViewController=PHPickerViewController(configuration: configuration)
        controller.delegate=context.coordinator
        
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate
    {
        var parent: EditImagePicker
        
        init(parent: EditImagePicker)
        {
            self.parent=parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
        {
            if let image=results.first?.itemProvider
            {
                image.loadObject(ofClass: UIImage.self)
                {(image, error) in
                    DispatchQueue.main.async
                    {
                        if let data=(image as? UIImage)?.jpegData(compressionQuality: self.parent.quality)
                        {
                            self.parent.imageData=data
                            self.parent.showPicker.toggle()
                        }
                    }
                }
            }
            else
            {
                self.parent.showPicker.toggle()
            }
        }
    }
}
