//
//  ImageResizer.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import UIKit

public struct ImageResizer
{
    var targetWidth: CGFloat
    
    //MARK: resize URL
    public func resize(at url: URL) -> UIImage?
    {
        guard let image=UIImage(contentsOfFile: url.path) else
        {
            return nil
        }
        return self.resize(image: image)
    }
    //MARK: UIImage
    public func resize(image: UIImage) -> UIImage
    {
        let originalSize=image.size
        let targetSize=CGSize(width: targetWidth, height: targetWidth*originalSize.height/originalSize.width)
        let renderer=UIGraphicsImageRenderer(size: targetSize)
        return renderer.image
        {context in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    //MARK: resize Data
    public func resize(data: Data) -> UIImage?
    {
        guard let image=UIImage(data: data) else
        {
            return nil
        }
        return self.resize(image: image )
    }
}
