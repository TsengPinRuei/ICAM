//
//  Photo_.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/17.
//

import Foundation
import SwiftUI

extension Photo
{
    //MARK: compressedData
    public var compressedData: Data?
    {
        ImageResizer(targetWidth: 800).resize(data: originalData)?.jpegData(compressionQuality: 0.5)
    }
    //MARK: image
    public var image: UIImage?
    {
        guard let data=self.compressedData
        else
        {
            return nil
        }
        return UIImage(data: data)
    }
    //MARK: thumbnailData
    public var thumbnailData: Data?
    {
        ImageResizer(targetWidth: 100).resize(data: originalData)?.jpegData(compressionQuality: 0.5)
    }
    //MARK: thumbnailImage
    public var thumbnailImage: UIImage?
    {
        guard let data=self.thumbnailData
        else
        {
            return nil
        }
        return UIImage(data: data)
    }
}
