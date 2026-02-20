//
//  TextToImageView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import SwiftUI
import SwiftUICharts

struct TextToImageView: View
{
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var openAI=OpenAIService()
    
    @State private var loading=false
    @State private var save: Bool=false
    @State private var showImage: Bool=false
    @State private var prompt: String=""
    @State private var title: String="發揮你的想像力吧"
    @State private var strokeWidth: CGFloat=3
    @State private var strokeColor: Color=Color.black
    @State private var image: UIImage?
    @State private var setPrestyle: [(String, String)]=[]
    @State private var setStyle: (String, String)=(ImageStyle().style[0].0, ImageStyle().style[0].1)
    
    //MARK: 繪製圖片
    private func getImage() async
    {
        //MARK: 有輸入
        if(!self.prompt.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.loading=true
            Task
            {
                var prompt: String=self.setStyle.1
                
                for i in self.setPrestyle
                {
                    prompt=prompt.appending(", ").appending(i.1)
                }
                prompt=prompt.appending(", ").appending(self.prompt)
                
                let result=await openAI.generateImageByText(prompt: prompt)
                
                //MARK: CoreData
                if let result=result
                {
                    let data=TextToImage(context: self.context)
                    
                    data.textC=self.setPrompt(english: false).replacingOccurrences(of: ", ", with: ",")
                    data.textE=self.setPrompt(english: true).replacingOccurrences(of: ", ", with: ",")
                    data.image=result.pngData()
                    data.time=Date()
                    
                    do
                    {
                        try self.context.save()
                    }
                    catch
                    {
                        print("TextToImageView CoreData Save Data Error: \(error.localizedDescription)")
                    }
                }
                else
                {
                    withAnimation(.easeInOut)
                    {
                        self.prompt=""
                        self.title="用字敏感\n請重新輸入"
                    }
                }
                
                self.loading=false
                self.image=result
            }
        }
        //MARK: 無輸入
        else
        {
            withAnimation(.easeInOut)
            {
                self.strokeWidth=8
                self.strokeColor=Color(red: 200/255, green: 0/255, blue: 0/255)
            }
            withAnimation(.easeInOut.delay(0.3))
            {
                self.strokeColor=Color.black
                self.strokeWidth=3
            }
            withAnimation(.easeInOut.delay(0.6))
            {
                self.strokeColor=Color(red: 200/255, green: 0/255, blue: 0/255)
                self.strokeWidth=8
            }
            withAnimation(.easeInOut.delay(0.9))
            {
                self.strokeColor=Color.black
                self.strokeWidth=3
            }
            withAnimation(.easeInOut.delay(1.2))
            {
                self.strokeColor=Color(red: 200/255, green: 0/255, blue: 0/255)
                self.strokeWidth=8
            }
            withAnimation(.easeInOut.delay(1.5))
            {
                self.strokeColor=Color.black
                self.strokeWidth=3
            }
        }
    }
    //MARK: 儲存圖片
    private func saveImage(album: String, image: UIImage) async
    {
        let album=ImageAlbum(name: album)
        
        album.save(image: image)
        {result in
            switch(result)
            {
                case .success(_):
                    self.loading=false
                case .failure(let error):
                    print("TextToImageView: \(error.localizedDescription)")
                    self.loading=false
            }
        }
    }
    //MARK: 設定關鍵字參數
    private func setPrompt(english: Bool) -> String
    {
        var prompt: String="\(english ? self.setStyle.1:self.setStyle.0), "
        
        for i in self.setPrestyle
        {
            prompt.append("\(english ? i.1:i.0), ")
        }
        prompt.append(self.prompt)
        
        return prompt
    }
    
    var body: some View
    {
        ZStack
        {
            VStack(spacing: 30)
            {
                ZStack
                {
                    //MARK: 圖片結果
                    if let image=self.image
                    {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .overlay
                            {
                                if(self.save)
                                {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                        .overlay
                                        {
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50)
                                                .foregroundStyle(.green)
                                                .padding()
                                                .background(.ultraThickMaterial)
                                                .clipShape(Circle())
                                                .transition(.opacity)
                                                .onAppear
                                                {
                                                    withAnimation(.easeInOut.delay(0.5))
                                                    {
                                                        self.save=false
                                                    }
                                                }
                                        }
                                }
                            }
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 5)
                            .onTapGesture
                            {
                                withAnimation(.easeInOut)
                                {
                                    self.showImage.toggle()
                                }
                            }
                    }
                    else
                    {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.clear)
                            .scaledToFit()
                            .overlay
                            {
                                //MARK: 載入畫面
                                if(self.loading)
                                {
                                    LoadingView(title: "正在生產圖片...")
                                }
                                //MARK: 預設畫面
                                else
                                {
                                    Text((self.setPrestyle.isEmpty && self.prompt.isEmpty) ? self.title:self.setPrompt(english: true))
                                        .font((self.setPrestyle.isEmpty && self.prompt.isEmpty) ? .title:.body)
                                        .foregroundStyle(.black)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .transition(.opacity.animation(.easeInOut))
                                }
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                
                VStack(alignment: .leading, spacing: 5)
                {
                    Text("視覺效果")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.black)
                    
                    //MARK: 視覺效果
                    StyleView(setStyle: self.$setStyle, prompt: self.$prompt)
                    
                    //MARK: 品質風格
                    PrestyleView(setPrestyle: self.$setPrestyle)
                }
                .padding(.horizontal)
            }
            
            //MARK: 完整圖片
            ImageView(showImage: self.$showImage, image: self.image ?? UIImage()).opacity(self.showImage ? 1:0)
        }
        .padding(.bottom, self.showImage ? 0:15)
        .background(GradientBackColor())
        .ignoresSafeArea(.keyboard)
        .navigationTitle("文字轉圖片")
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
            
            //MARK: 下載
            ToolbarItem(placement: .topBarTrailing)
            {
                Button
                {
                    Task
                    {
                        await self.saveImage(album: "文字轉圖片", image: self.image!)
                        withAnimation(.easeInOut)
                        {
                            self.save=true
                        }
                    }
                }
                label:
                {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(height: 30)
                }
                .disabled(self.image==nil)
                .opacity(self.image==nil ? 0.5:1)
                .animation(.easeInOut, value: self.image)
            }
            
            //MARK: 分享
            ToolbarItem(placement: .topBarTrailing)
            {
                ShareLink(
                    item: Image(uiImage: self.image ?? UIImage()),
                    preview: SharePreview("ICAM", image: Image(uiImage: self.image ?? UIImage()))
                )
                {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(height: 30)
                }
                .disabled(self.image==nil)
                .opacity(self.image==nil ? 0.5:1)
                .animation(.easeInOut, value: self.image)
            }
            
            //MARK: 輸入
            ToolbarItem(placement: .bottomBar)
            {
                HStack(alignment: .center, spacing: 0)
                {
                    //MARK: TextField
                    TextField("想像些什麼呢？", text: self.$prompt)
                        .font(.title3)
                        .autocapitalization(.none)
                        .submitLabel(.done)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                        .background(Capsule().stroke(self.strokeColor, lineWidth: self.strokeWidth))
                        .overlay
                        {
                            if(!self.prompt.isEmpty)
                            {
                                Button
                                {
                                    self.prompt=""
                                }
                                label:
                                {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.gray)
                                        .frame(height: 20)
                                        .transition(.opacity.animation(.easeInOut))
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    
                    //MARK: 發送
                    Button
                    {
                        Task
                        {
                            withAnimation(.easeInOut)
                            {
                                self.image=nil
                            }
                            
                            await self.getImage()
                        }
                    }
                    label:
                    {
                        Image(systemName: "paperplane")
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(self.loading ? .gray:Color(.tool))
                            .clipShape(Circle())
                    }
                    .disabled(self.loading)
                }
            }
            
            //MARK: 鍵盤
            ToolbarItem(placement: .keyboard)
            {
                HStack
                {
                    Text(self.prompt)
                        .font(.body)
                        .foregroundStyle(.black)
                        .padding(5)
                        .overlay
                        {
                            Rectangle()
                                .stroke(.black, lineWidth: 1)
                                .opacity(self.prompt.isEmpty ? 0:1)
                                .animation(.easeInOut, value: self.prompt)
                        }
                    
                    Spacer()
                    
                    Button("確認")
                    {
                        UIApplication.shared.dismissKeyboard()
                    }
                    .foregroundStyle(.blue)
                }
            }
        }
        .animation(.easeInOut, value: self.title)
        //MARK: 啟動OpenAI
        .onAppear
        {
            self.openAI.setUp()
        }
    }
}
