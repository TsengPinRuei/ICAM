//
//  UsageView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/4.
//

import SwiftUI
import SwiftUICharts

struct UsageView: View
{
    @State private var i2i: ChartData =
    ChartData(
        values:
            {
                var data: [(String, Double)]=[]
                
                for i in 1...9
                {
                    data.append(("\(10-i)天前", Double(Int.random(in: 0...10))))
                }
                data.append(("今天", Double(Int.random(in: 0...10))))
                
                return data
            }()
    )
    @State private var t2i: ChartData =
    ChartData(
        values:
            {
                var data: [(String, Double)]=[]
                
                for i in 1...9
                {
                    data.append(("\(10-i)天前", Double(Int.random(in: 0...10))))
                }
                data.append(("今天", Double(Int.random(in: 0...10))))
                
                return data
            }()
    )
    
    private let style: ChartStyle =
    ChartStyle(
        backgroundColor: .white.opacity(0.5),
        accentColor: Color(red: 78/255, green: 167/255, blue: 255/255),
        secondGradientColor: Color(red: 78/255, green: 167/255, blue: 255/255),
        textColor: .black,
        legendTextColor: .black,
        dropShadowColor: .gray
    )
    
    var body: some View
    {
        ZStack
        {
            //MARK: 背景顏色
            GradientBackColor()
            
            VStack(spacing: 50)
            {
                //MARK: 文字轉圖片
                VStack(spacing: 5)
                {
                    Text("文字轉圖片")
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    BarChartView(
                        data: self.t2i,
                        title: "天數／用量",
                        style: self.style,
                        form: ChartForm.extraLarge
                    )
                }
                
                //MARK: 圖片轉圖片
                VStack(spacing: 5)
                {
                    Text("圖片轉圖片")
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    BarChartView(
                        data: self.i2i,
                        title: "天數／用量",
                        style: self.style,
                        form: ChartForm.extraLarge
                    )
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("用量")
        .toolbarTitleDisplayMode(.inline)
    }
}
