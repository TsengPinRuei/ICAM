//
//  HomeViewButton.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/23.
//

import SwiftUI

struct HomeViewButton: View
{
    let width: CGFloat
    let image: String
    
    var body: some View
    {
        Image(self.image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: self.width)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: .black, radius: 1)
    }
}
