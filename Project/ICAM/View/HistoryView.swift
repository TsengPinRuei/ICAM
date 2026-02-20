//
//  HistoryView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/31.
//

import SwiftUI
import SwiftUICharts

struct HistoryView: View
{
    @AppStorage("countUsage") private var countUsage: [Int]=[0, 0]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showImage: Bool=false
    @State private var showLanguage: Bool=false
    @State private var select: Int=0
    @State private var language: Int=0
    @State private var text: String=""
    
    //MARK: 搜尋建議列表
    private func SuggestionView(suggestion: [(String, String)]) -> some View
    {
        Section(suggestion.count==20 ? "視覺效果":"品質風格")
        {
            ForEach(suggestion.indices, id: \.self)
            {index in
                VStack(alignment: .leading)
                {
                    Text(suggestion[index].0)
                    Text(suggestion[index].1)
                }
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.01))
                .searchCompletion("\(self.language==0 ? suggestion[index].0:suggestion[index].1)")
            }
            .listRowSeparatorTint(.primary)
        }
        .font(.title.bold())
        .headerProminence(.increased)
    }
    
    //MARK: 選擇器設定
    init()
    {
        let picker=UISegmentedControl.appearance()
        
        picker.backgroundColor=UIColor(named: "ToolColor")
        picker.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 14)
            ],
            for: .normal
        )
        picker.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 18, weight: .bold)
            ],
            for: .selected
        )
    }
    
    var body: some View
    {
        ZStack
        {
            //MARK: 背景顏色
            GradientBackColor().ignoresSafeArea(.all)
            
            if(self.select==0)
            {
                //MARK: HistoryTextToImageView
                HistoryTextToImageView(
                    searchText: self.$text,
                    showLanguage: self.$showLanguage,
                    language: self.$language,
                    select: self.$select,
                    showImage: self.$showImage
                )
                //MARK: 搜尋列
                .searchable(
                    text: self.$text,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "視覺效果 品質風格"
                )
                //MARK: 搜尋建議
                .searchSuggestions
                {
                    if(self.text.isEmpty)
                    {
                        self.SuggestionView(suggestion: ImageStyle().style).transition(.opacity.animation(.easeInOut))
                        self.SuggestionView(suggestion: ImageStyle().prestyle).transition(.opacity.animation(.easeInOut))
                    }
                }
                .autocorrectionDisabled()
                .transition(.opacity.animation(.easeInOut))
            }
            else
            {
                //MARK: HistoryImageToImageView
                HistoryImageToImageView(select: self.$select, showImage: self.$showImage).transition(.opacity.animation(.easeInOut))
            }
        }
        .navigationTitle("歷史紀錄")
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .bottomBar)
        .toolbar(self.showImage ? .hidden:.visible, for: .navigationBar)
        .toolbar(self.showImage ? .hidden:.visible, for: .bottomBar)
        .navigationBarBackButtonHidden()
        .toolbar
        {
            //MARK: BackButton
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
            
            //MARK: UsageView
            ToolbarItem(placement: .topBarTrailing)
            {
                NavigationLink(destination: UsageView())
                {
                    Text("用量")
                }
            }
            
            //MARK: 選擇器
            ToolbarItem(placement: .bottomBar)
            {
                Picker("", selection: self.showLanguage ? self.$language:self.$select)
                {
                    if(self.showLanguage)
                    {
                        Text("中文").tag(0)
                        
                        Text("英文").tag(1)
                    }
                    else
                    {
                        Text("文字轉圖片").tag(0)
                        
                        Text("圖片轉圖片").tag(1)
                    }
                }
                .pickerStyle(.segmented)
                .animation(.none, value: self.showLanguage)
            }
        }
    }
}
