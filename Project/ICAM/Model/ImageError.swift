//
//  TextToImageError.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import Foundation

struct ImageError: ErrorProtocol
{
    var title: String?
    var code: Int
    var errorDescription: String?{ return self._description }
    var failureReason: String?{ return self._description }
    
    private var _description: String
    
    //MARK: init
    init(title: String?, description: String, code: Int)
    {
        self.title=title ?? "Error"
        self._description=description
        self.code=code
    }
}
