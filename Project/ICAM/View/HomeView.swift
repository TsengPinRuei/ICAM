//
//  HomeView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import SwiftUI

struct HomeView: View
{
    private let link: [[String]]=[["homeCamera", "homeHistory"], ["homeT2I", "homeI2I"]]
    
    //MARK: 設定連結
    private func setDestination(i: Int, j: Int) -> some View
    {
        if(i==0 && j==0)
        {
            return AnyView(CameraView())
        }
        else if(i==0 && j==1)
        {
            return AnyView(HistoryView())
        }
        else if(i==1 && j==0)
        {
            return AnyView(TextToImageView())
        }
        else if(i==1 && j==1)
        {
            return AnyView(ImageToImageView())
        }
        return AnyView(ProgressView())
    }
    
    var body: some View
    {
        ZStack(alignment: .bottom)
        {
            //MARK: Logo
            Capsule()
                .fill(.ultraThinMaterial)
                .frame(width: 1000, height: 1000)
                .overlay(alignment: .bottom)
                {
                    Image(.ICAM)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                .offset(y: -UIScreen.main.bounds.height/1.5)
            
            //MARK: 連結按鈕
            VStack(spacing: 20)
            {
                ForEach(0..<self.link.count, id: \.self)
                {i in
                    HStack(spacing: 20)
                    {
                        ForEach(0..<self.link[i].count, id: \.self)
                        {j in
                            NavigationLink(destination: self.setDestination(i: i, j: j))
                            {
                                HomeViewButton(
                                    width: UIScreen.main.bounds.width/2.5,
                                    image: self.link[i][j]
                                )
                            }
                        }
                    }
                }
            }
            .offset(y: -UIScreen.main.bounds.height/4.5)
        }
        .background(GradientBackColor())
        .toolbar
        {
            //MARK: InstructionView
            ToolbarItem(placement: .topBarTrailing)
            {
                NavigationLink(destination: InstructionView())
                {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(height: 40)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
            
            //MARK: EditImageView
            ToolbarItem(placement: .bottomBar)
            {
                HStack
                {
                    Spacer()
                    
                    Text("ＩＣＡＭ")
                        .font(.title)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
//                    NavigationLink(destination: EditImageView())
//                    {
//                        Image(systemName: "chevron.right")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 30)
//                            .foregroundStyle(Color(.tool))
//                    }
                }
            }
        }
    }
}
