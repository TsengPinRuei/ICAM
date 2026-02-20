//
//  InstructionView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/1.
//

import SwiftUI
import UIKit

struct InstructionView: View
{
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAPI: Bool=false
    @State private var showMail: Bool=false
    
    //MARK: 游標設定
    init()
    {
        let appearance: UIPageControl=UIPageControl.appearance()
        appearance.currentPageIndicatorTintColor=UIColor(named: "ToolColor")
        appearance.pageIndicatorTintColor=UIColor.black.withAlphaComponent(0.5)
    }
    
    var body: some View
    {
        ZStack
        {
            //MARK: 背景顏色
            Color.white.ignoresSafeArea(.all)
            
            VStack
            {
                //MARK: TabView
                TabView
                {
                    ForEach(1...8, id: \.self)
                    {index in
                        Image("intro".appending("\(index)"))
                            .resizable()
                            .scaledToFit()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                //MARK: 聯絡我們
                Button("聯絡我們")
                {
                    self.showMail.toggle()
                }
                .bold()
                .font(.title3)
            }
        }
        //MARK: APIKeyView
        .sheet(isPresented: self.$showAPI)
        {
            APIKeyView()
                .presentationDetents([.medium])
                .presentationBackground(.ultraThinMaterial)
        }
        //MARK: 聯絡我們
        .sheet(isPresented: self.$showMail)
        {
            VStack(spacing: 30)
            {
                VStack(spacing: 5)
                {
                    Text("長按複製").font(.title3)
                    
                    Capsule().frame(width: 100, height: 3)
                }
                
                Text("gblin1108@gmail.com")
                    .font(.title)
                    .foregroundStyle(Color(.tool))
                    .textSelection(.enabled)
            }
            .presentationDetents([.fraction(0.2)])
            .presentationBackground(.ultraThickMaterial)
        }
        .navigationTitle("使用說明")
        .toolbarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.tool), for: .navigationBar)
        .navigationBarBackButtonHidden()
        //MARK: Toolbar
        .toolbar
        {
            ToolbarItem(placement: .cancellationAction)
            {
                Button
                {
                    self.dismiss()
                }
                label:
                {
                    HStack(spacing: 0)
                    {
                        Image(systemName: "chevron.left").bold()
                        
                        Text("ＩＣＡＭ")
                    }
                    .font(.body)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing)
            {
                Button("我的金鑰")
                {
                    self.showAPI.toggle()
                }
            }
        }
    }
}
