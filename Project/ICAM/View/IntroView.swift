//
//  IntroView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import SwiftUI

struct IntroView: View
{
    @State private var goHome: Bool=false
    @State private var showText: Bool=false
    @State private var image: ImageResource = .ICAMB
    
    var body: some View
    {
        NavigationStack
        {
            if(self.goHome)
            {
                //MARK: HomeView
                HomeView()
            }
            else
            {
                ZStack
                {
                    //MARK: 背景顏色
                    GradientBackColor()
                    
                    VStack
                    {
                        Spacer()
                        
                        //MARK: 提示字串
                        if(self.showText)
                        {
                            Text("點擊進入應用程式")
                                .bold()
                                .font(.title)
                                .transition(.push(from: .bottom))
                        }
                        
                        //MARK: 圖片
                        Image(self.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 20))
                            .overlay
                            {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(.tool), lineWidth: 5)
                                    .opacity(self.showText ? 1:0)
                            }
                        
                        Spacer()
                        
                        //MARK: 標題文字
                        if(self.showText)
                        {
                            Group
                            {
                                Text("ＩＣＡＭ").font(.title)
                                
                                Text("I CAN draw everything you want.").font(.title3)
                            }
                            .bold()
                            .transition(.push(from: .bottom))
                        }
                    }
                    .padding()
                }
                //MARK: 進入
                .onTapGesture
                {
                    if(self.showText)
                    {
                        withAnimation(.smooth)
                        {
                            self.goHome=true
                        }
                    }
                }
                //MARK: 動畫
                .onAppear
                {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1)
                    {
                        withAnimation(.smooth(duration: 1.2))
                        {
                            self.showText=true
                            self.image = .ICAMW
                        }
                    }
                }
            }
        }
        .tint(.black)
    }
}
