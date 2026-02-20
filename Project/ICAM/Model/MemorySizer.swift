//
//  MemorySizer.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import UIKit

struct MemorySizer
{
    //MARK: size
    static func size(of data: Data) -> String
    {
        let bcf=ByteCountFormatter()
        bcf.allowedUnits=[.useMB]
        bcf.countStyle = .file
        let string=bcf.string(fromByteCount: Int64(data.count))
        return string
    }
}
