//
//  ErrorProtocol.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import Foundation

protocol ErrorProtocol: LocalizedError
{
    var title: String? { get }
    var code: Int { get }
}
