//
//  APIKeyView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/1.
//

import SwiftUI

struct APIKeyView: View
{
    @AppStorage("APIKey") private var apiKey: String=""
    
    @State private var key: String="sk-"
    @State private var text: String="如果您沒有金鑰，請至OpenAI官方網站取得金鑰。"
    
    //MARK: 檢查金鑰
    private func checkKey()
    {
        withAnimation(.easeInOut.speed(2))
        {
            if(!self.key.contains(" "))
            {
                self.apiKey=self.key
                self.text="儲存成功！您的OpenAI金鑰：\n「\(self.apiKey)。」"
            }
            else
            {
                self.text="您輸入的金鑰格式錯誤，請重新確認錯字及格式。"
            }
            
            self.key=""
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                List
                {
                    //MARK: 標題
                    Text("輸入或更新您的OpenAI金鑰\n以啟動服務")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .listRowBackground(Color.white.opacity(0.8))
                        .listRowSeparator(.hidden)
                    
                    //MARK: TextEditor
                    TextEditor(text: self.$key)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .onChange(of: self.key)
                        {(_, new) in
                            if(new.count<=3)
                            {
                                self.key="sk-"
                            }
                            else if(new.last?.isNewline == .some(true))
                            {
                                self.key.removeLast()
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.8))
                        .listRowSeparatorTint(.black)
                    
                    //MARK: 文字
                    Text(self.text)
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .listRowBackground(Color.white.opacity(0.8))
                    
                    //MARK: 連結
                    Link("點擊前往OpenAI官方網站", destination: URL(string: "https://openai.com")!)
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("OpenAI金鑰")
            .toolbarTitleDisplayMode(.large)
            //MARK: Toolbar
            .toolbar
            {
                ToolbarItem(placement: .topBarTrailing)
                {
                    if(self.key.count != 51)
                    {
                        Text("\(self.key.count) / 51")
                            .bold()
                            .foregroundStyle(self.key.count<51 ? .black:.red)
                            .colorMultiply(self.key.count<51 ? .white:.gray)
                    }
                    else
                    {
                        Button("儲存")
                        {
                            UIApplication.shared.dismissKeyboard()
                            self.checkKey()
                        }
                        .bold()
                    }
                }
            }
        }
        .tint(.black)
    }
}
