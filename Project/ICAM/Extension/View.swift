//
//  View.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/24.
//

import SwiftUI

extension View
{
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View
    {
        content(self)
    }
}
