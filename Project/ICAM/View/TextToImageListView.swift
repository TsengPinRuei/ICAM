//
//  TextToImageListView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/11/24.
//

import SwiftUI

struct TextToImageListView: View
{
    @Binding var showImage: Bool
    @Binding var save: Bool
    @Binding var sure: Bool
    @Binding var image: UIImage?
    
    @Environment(\.managedObjectContext) private var context
    
    var history: FetchedResults<TextToImage>
    
    //MARK: 刪除CoreData資料
    private func delete(at index: IndexSet)
    {
        do
        {
            for i in index
            {
                self.context.delete(self.history[i])
            }
            
            try self.context.save()
        }
        catch
        {
            print("HistoryTextToImageView Delete Data Error: \(error.localizedDescription)")
        }
    }
    //MARK: 取得輸入參數
    private func getPrompt(text: String) -> String
    {
        let prompt: [String]=text.components(separatedBy: ",")
        return prompt[prompt.count-1]
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
                    self.save.toggle()
                case .failure(let error):
                    print("TextToImageView: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View
    {
        //MARK: 文字轉圖片
        List
        {
            ForEach(self.history, id: \.self)
            {index in
                if let textC=index.textC,
                   let textE=index.textE,
                   let data=index.image,
                   let image=UIImage(data: data)
                {
                    Button
                    {
                        DispatchQueue.main.async
                        {
                            self.image=image
                            withAnimation(.easeInOut)
                            {
                                self.showImage.toggle()
                            }
                        }
                    }
                    label:
                    {
                        //MARK: 圖片
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay
                            {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.6))
                                    //MARK: 參數
                                    .overlay
                                    {
                                        HStack(spacing: 10)
                                        {
                                            VStack(alignment: .leading)
                                            {
                                                //MARK: 中文參數
                                                ForEach(textC.components(separatedBy: ","), id: \.self)
                                                {index in
                                                    if(index != self.getPrompt(text: textC))
                                                    {
                                                        HStack
                                                        {
                                                            Circle()
                                                                .scaledToFit()
                                                                .frame(height: 10)
                                                            
                                                            Text(index)
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            VStack(alignment: .leading)
                                            {
                                                //MARK: 英文參數
                                                ForEach(textE.components(separatedBy: ","), id: \.self)
                                                {index in
                                                    if(index != self.getPrompt(text: textE))
                                                    {
                                                        HStack
                                                        {
                                                            Circle()
                                                                .scaledToFit()
                                                                .frame(height: 10)
                                                                .opacity(0.01)
                                                            
                                                            Text(index).opacity(index=="8K" ? 0.01:1)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .bold()
                                        .font(.title3)
                                        .padding(.horizontal, 10)
                                    }
                                    //MARK: 標題
                                    .overlay(alignment: .top)
                                    {
                                        VStack(spacing: 0)
                                        {
                                            Text(self.getPrompt(text: textC))
                                                .bold()
                                                .font(.largeTitle)
                                            
                                            Capsule().frame(height: 1)
                                        }
                                    }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black))
                    }
                    .padding(1)
                    .padding(.bottom)
                    //MARK: 下載按鈕
                    .swipeActions(edge: .leading)
                    {
                        Button
                        {
                            if let data=index.image,
                               let image=UIImage(data: data)
                            {
                                Task
                                {
                                    await self.saveImage(album: "文字轉圖片", image: image)
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "arrow.down.to.line").foregroundStyle(.white)
                        }
                        .tint(.green)
                    }
                }
            }
            //MARK: 刪除按鈕
            .onDelete(perform: self.delete(at:))
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
    }
}
