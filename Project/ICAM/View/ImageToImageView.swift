//
//  ImageToImageView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/24.
//

import SwiftUI

struct ImageToImageView: View
{
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var openAI=OpenAIService()
    
    @State private var loading: Bool=false
    @State private var generate: Bool=false
    @State private var save: Bool=false
    @State private var showImage: Bool=false
    @State private var setStyle: String=ImageStyle().style[0].1
    @State private var image: UIImage?
    
    //MARK: 轉換圖片
    private func getImage()
    {
        self.loading=true
        withAnimation(.easeInOut)
        {
            self.generate=true
        }
        
        if let image=self.image
        {
            Task
            {
                //MARK: CoreData
                if let result=await self.openAI.generaImageByImage(image: image)
                {
                    let data=ImageToImage(context: self.context)
                    
                    data.image=result.pngData()
                    data.time=Date()
                    
                    do
                    {
                        try self.context.save()
                    }
                    catch
                    {
                        print("ImageToImageView CoreData Save Data Error: \(error.localizedDescription)")
                    }
                    
                    self.image=result
                }
                else
                {
                    self.image=nil
                }
                
                self.loading=false
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
                    print("ImageToImageView: \(error.localizedDescription)")
                    self.loading=false
            }
        }
    }
    
    var body: some View
    {
        ZStack
        {
            ZStack
            {
                if(self.loading)
                {
                    //MARK: 載入畫面
                    LoadingView(title: "正在繪製圖片中...")
                }
                else if(self.generate)
                {
                    //MARK: 圖片結果
                    if let image=self.image
                    {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            //MARK: 下載成功
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
                            .transition(.opacity.animation(.easeInOut))
                            .onTapGesture
                            {
                                withAnimation(.easeInOut)
                                {
                                    self.showImage.toggle()
                                }
                            }
                    }
                    //MARK: 繪製失敗
                    else
                    {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.clear)
                            .background(.ultraThinMaterial)
                            .overlay
                            {
                                Text("請嘗試使用容量較小的圖片")
                                    .font(.title)
                                    .foregroundStyle(.black)
                            }
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 5)
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
                else
                {
                    //MARK: 選擇圖片
                    ImagePicker(
                        title: "拖曳圖片至此處",
                        subtitle: "或點擊此處新增圖片",
                        systemImage: "square.and.arrow.up",
                        tint: Color.black.opacity(0.5)
                    )
                    {image in
                        self.image=image
                    }
                    .transition(.opacity.animation(.easeInOut))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            
            //MARK: 完整圖片
            ImageView(showImage: self.$showImage, image: self.image ?? UIImage())
                .opacity(self.showImage ? 1:0)
        }
        .padding(.vertical)
        .background(GradientBackColor())
        .navigationTitle("圖片轉圖片")
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
                        await self.saveImage(album: "圖片轉圖片", image: self.image!)
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
                .disabled(self.image==nil || self.loading)
                .opacity((self.image==nil || self.loading) ? 0.5:1)
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
                .disabled(self.image==nil || self.loading)
                .opacity((self.image==nil || self.loading) ? 0.5:1)
                .animation(.easeInOut, value: self.image)
            }
            
            //MARK: 轉換按鈕
            ToolbarItem(placement: .bottomBar)
            {
                Button
                {
                    if(self.generate)
                    {
                        withAnimation(.easeInOut)
                        {
                            self.image=nil
                            self.generate=false
                        }
                    }
                    else
                    {
                        self.getImage()
                    }
                }
                label:
                {
                    Text(self.generate ? "捨棄圖片":"轉換圖片")
                        .bold()
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(((self.image==nil && !self.generate) || (self.loading && self.generate)) ? .gray:.black)
                        .clipShape(.rect(cornerRadius: 10))
                        .animation(.easeInOut, value: self.generate)
                }
                .disabled((self.image==nil && !self.generate) || (self.loading && self.generate))
            }
        }
        .onAppear
        {
            self.openAI.setUp()
        }
    }
}
