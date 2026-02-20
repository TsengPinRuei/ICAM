//
//  Array.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/31.
//

import Foundation

extension Array: RawRepresentable where Element: Codable
{
    //MARK: init
    public init?(rawValue: String)
    {
        guard let data=rawValue.data(using: .utf8),
              let result=try? JSONDecoder().decode([Element].self, from: data)
        else
        {
            return nil
        }
        
        self=result
    }
    
    //MARK: rawValue
    public var rawValue: String
    {
        guard let data=try? JSONEncoder().encode(self),
              let result=String(data: data, encoding: .utf8)
        else
        {
            return "[]"
        }
        
        return result
    }
}
