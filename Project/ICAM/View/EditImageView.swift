//
//  ImageEditView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI

struct EditImageView: View
{
    @ObservedObject var openAI=OpenAIService()
    
    @StateObject var canvas: Canvas=Canvas()
    
    @State private var complete: (Bool, String)=(false, "")
    @State private var text: String=""
    @State private var image: UIImage?
    @State private var mask: UIImage?
    @State private var result: UIImage?
    
    //MARK: 取得圖片
    private func getImage(prompt: String)
    {
        if let image=self.image,
           let mask=self.mask
        {
            Task
            {
                await self.openAI.editImage(image: image, mask: mask, prompt: prompt)
                {(image, error) in
                    withAnimation(.easeInOut)
                    {
                        if let image=image
                        {
                            self.result=image
                        }
                        else if let error=error
                        {
                            self.result=nil
                            self.complete.1=String(describing: error)
                        }
                        else
                        {
                            self.result=nil
                        }
                        
                        self.image=nil
                        self.mask=nil
                        self.text=""
                        self.canvas.stack=[]
                        self.complete.0=true
                    }
                }
            }
        }
    }
    
    var body: some View
    {
        ZStack(alignment: .top)
        {
            //MARK: 背景顏色
            GradientBackColor()
            
            //MARK: 使用說明
            VStack(spacing: 20)
            {
                VStack(spacing: 0)
                {
                    HStack(spacing: 0)
                    {
                        Text("拖曳\t\t\t").bold()
                        Text("移動圖片")
                    }
                    HStack(spacing: 0)
                    {
                        Text("長按\t\t\t").bold()
                        Text("覆蓋圖片")
                    }
                    HStack(spacing: 0)
                    {
                        Text("雙手操作\t\t").bold()
                        Text("旋轉圖片")
                    }
                    HStack(spacing: 0)
                    {
                        Text("點擊兩下\t\t").bold()
                        Text("刪除圖片")
                    }
                }
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background
                {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 3)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                if(self.complete.0)
                {
                    //MARK: 結果
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .scaledToFit()
                        .overlay
                        {
                            if let result=self.result
                            {
                                Image(uiImage: result)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                            else
                            {
                                Text(self.complete.1)
                                    .bold()
                                    .font(.body)
                                    .padding()
                            }
                        }
                        .padding()
                }
                else
                {
                    //MARK: CanvasView
                    CanvasView(height: 400)
                        .environmentObject(self.canvas)
                        .onAppear
                        {
                            self.canvas.stack
                                .append(
                                    StackItem(
                                        id: "MASKRECTANGLE",
                                        view: AnyView(
                                            Rectangle()
                                                .fill(.white)
                                                .scaledToFit()
                                                .frame(height: 100)
                                        )
                                    )
                                )
                        }
                }
                
                //MARK: 預設標題
                TextField("想要填充些什麼？", text: self.$text)
                    .font(.title3)
                    .autocapitalization(.none)
                    .submitLabel(.done)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(.rect(cornerRadius: 10))
                    .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1))
                    .padding(.horizontal)
            }
        }
        .navigationTitle("圖片編輯")
        .toolbarTitleDisplayMode(.large)
        .toolbar
        {
            //MARK: 完成按鈕
            ToolbarItem(placement: .topBarTrailing)
            {
                Button("完成")
                {
                    self.mask=self.canvas.saveImage(height: 400)
                    {
                        CanvasView().environmentObject(self.canvas)
                    }
                    
                    self.getImage(prompt: self.text)
                }
                .disabled(self.canvas.stack.count<=1 || self.text.isEmpty)
                .animation(.easeInOut, value: self.canvas.stack.count)
                .animation(.easeInOut, value: self.text)
            }
            
            if(self.canvas.stack.count<=1)
            {
                //MARK: 選擇照片按鈕
                ToolbarItem(placement: .bottomBar)
                {
                    Button
                    {
                        withAnimation(.easeInOut)
                        {
                            self.complete=(false, "")
                        }
                        
                        self.canvas.showEditPicker.toggle()
                    }
                    label:
                    {
                        HStack(spacing: 20)
                        {
                            Text("選擇照片").font(.title)
                            
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                }
            }
        }
        //MARK: 啟動OpenAI
        .onAppear
        {
            self.openAI.setUp()
        }
        .alert(self.canvas.errorMessage, isPresented: self.$canvas.showError) {}
        //MARK: EditImagePicker
        .sheet(isPresented: self.$canvas.showEditPicker)
        {
            if let image=UIImage(data: self.canvas.imageData)
            {
                self.canvas.addImage(image: image)
                self.image=image.scale(width: 512)
            }
        }
        content:
        {
            EditImagePicker(showPicker: self.$canvas.showEditPicker, imageData: self.$canvas.imageData)
        }
    }
}
