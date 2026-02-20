//
//  StyleView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/11/25.
//

import SwiftUI

struct StyleView: View
{
    @Binding var setStyle: (String, String)
    @Binding var prompt: String
    
    @State private var styleImage: [ImageResource]=ImageStyle().image
    
    private let style: [(String, String)]=ImageStyle().style
    
    var body: some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack(spacing: 20)
            {
                ForEach(0..<self.style.count, id: \.self)
                {index in
                    VStack(spacing: 5)
                    {
                        //MARK: 標題
                        Text(self.style[index].0)
                            .bold()
                            .font(.title3)
                            .foregroundStyle(self.setStyle.1==self.style[index].1 ? .black:.gray)
                        
                        //MARK: 範例圖
                        Image(self.styleImage[index])
                            .resizable()
                            .frame(width: 150, height: 200)
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(color: .black, radius: 3)
                            .overlay
                            {
                                RoundedRectangle(cornerRadius: 10).stroke(self.setStyle.1==self.style[index].1 ? .black:.clear, lineWidth: 2)
                            }
                    }
                    .onTapGesture
                    {
                        self.setStyle=(self.style[index].0, self.style[index].1)
                    }
                }
            }
            .padding(5)
        }
    }
}
