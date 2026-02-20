//
//  AVCaptureDevice_DiscoverySession.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation
import AVFoundation

extension AVCaptureDevice.DiscoverySession
{
    var uniqueDevicePositionsCount: Int
    {
        var uniqueDevicePositions=[AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position)
        {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
}
