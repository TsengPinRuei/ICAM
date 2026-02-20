//
//  CameraService_.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import Foundation

extension CameraService
{
    //MARK: CaptureMode
    enum CaptureMode: Int
    {
        case photo = 0
        case movie = 1
    }
    //MARK: DepthDataDeliveryMode
    enum DepthDataDeliveryMode
    {
        case on
        case off
    }
    //MARK: LivePhotoMode
    enum LivePhotoMode
    {
        case on
        case off
    }
    //MARK: PortraitEffectsMatteDeliveryMode
    enum PortraitEffectsMatteDeliveryMode
    {
        case on
        case off
    }
    //MARK: SessionSetupResult
    enum SessionSetupResult
    {
        case success
        case notAuthorized
        case configurationFailed
    }
}
