//
//  AlertError.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/17.
//

import Foundation

public struct AlertError
{
    public var title: String=""
    public var message: String=""
    public var primaryButtonTitle="接受"
    public var secondaryButtonTitle: String?
    public var primaryAction: (() -> ())?
    public var secondaryAction: (() -> ())?
    
    //MARK: init
    public init(
        title: String="",
        message: String="",
        primaryButtonTitle: String="接受",
        secondaryButtonTitle: String?=nil,
        primaryAction: (() -> ())?=nil,
        secondaryAction: (() -> ())?=nil
    )
    {
        self.title=title
        self.message=message
        self.primaryAction=primaryAction
        self.primaryButtonTitle=primaryButtonTitle
        self.secondaryAction=secondaryAction
    }
}
