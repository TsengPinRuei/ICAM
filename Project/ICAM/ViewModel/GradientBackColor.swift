//
//  GradientBackColor.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/23.
//

import SwiftUI

struct GradientBackColor: View
{
    var body: some View
    {
        LinearGradient(
            colors: [.white, Color(.tool)],
            startPoint: .bottom,
            endPoint: .top
        )
        .ignoresSafeArea(.all)
    }
}
