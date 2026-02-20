//
//  LoadingView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/25.
//

import SwiftUI

struct LoadingView: View
{
    let title: String
    
    var body: some View
    {
        ProgressView(self.title)
            .tint(.black)
            .font(.title3)
            .foregroundStyle(.black)
            .controlSize(.large)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .transition(.opacity.animation(.easeInOut))
    }
}
