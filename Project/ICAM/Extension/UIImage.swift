//
//  UIImage.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/23.
//

import UIKit

extension UIImage
{
    func scale(width: CGFloat) -> UIImage
    {
        guard self.size.width != width
        else
        {
            return self
        }
        
        let scale=width/self.size.width
        let height=self.size.height * scale
        let size=CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
}
