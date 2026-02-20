//
//  UIApplication.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import SwiftUI

extension UIApplication
{
    func dismissKeyboard()
    {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
