//
//  ImageView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/30.
//

import SwiftUI

struct ImageView: View
{
    @Binding var showImage: Bool
    
    @State private var scale: CGFloat=0
    
    let image: UIImage
    
    var body: some View
    {
        ZStack
        {
            //MARK: 背景顏色
            Color.black
                .opacity(0.8)
                .onTapGesture
                {
                    withAnimation(.easeInOut)
                    {
                        self.showImage=false
                    }
                }
            
            //MARK: 圖片
            Image(uiImage: self.image)
                .resizable()
                .scaledToFit()
                .scaleEffect(1+self.scale)
                .onTapGesture
                {
                    withAnimation(.snappy)
                    {
                        self.scale=0
                    }
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged
                        {value in
                            self.scale=value-1
                        }
                        .onEnded
                        {value in
                            if(self.scale<0)
                            {
                                withAnimation(.snappy)
                                {
                                    self.scale=0
                                }
                            }
                        }
                )
        }
        .ignoresSafeArea(.all)
    }
}
