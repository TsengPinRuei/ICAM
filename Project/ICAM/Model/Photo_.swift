//
//  Photo.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/17.
//

import Foundation

public struct Photo: Equatable, Identifiable
{
    public var id: String
    public var originalData: Data
    
    //MARK: init
    public init(id: String=UUID().uuidString, originalData: Data)
    {
        self.id=id
        self.originalData=originalData
    }
}
