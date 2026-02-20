//
//  AVCaptureVideoOrientation.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import AVFoundation
import UIKit

extension AVCaptureVideoOrientation
{
    //MARK: device
    init?(deviceOrientation: UIDeviceOrientation)
    {
        switch deviceOrientation
        {
            case .portrait: self = .portrait
            case .portraitUpsideDown: self = .portraitUpsideDown
            case .landscapeLeft: self = .landscapeRight
            case .landscapeRight: self = .landscapeLeft
            default: return nil
        }
    }
    
    //MARK: interface
    init?(interfaceOrientation: UIInterfaceOrientation)
    {
        switch interfaceOrientation
        {
            case .portrait: self = .portrait
            case .portraitUpsideDown: self = .portraitUpsideDown
            case .landscapeLeft: self = .landscapeLeft
            case .landscapeRight: self = .landscapeRight
            default: return nil
        }
    }
}
