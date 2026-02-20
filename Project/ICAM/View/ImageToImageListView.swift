//
//  ImageToImageListView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/11/24.
//

import SwiftUI

struct ImageToImageListView: View
{
    @Binding var save: Bool
    @Binding var showImage: Bool
    @Binding var image: UIImage?
    
    @Environment(\.managedObjectContext) private var context
    
    var history: FetchedResults<ImageToImage>
    
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
            print("HistoryImageToImageView Delete Data Error: \(error.localizedDescription)")
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
                    self.save.toggle()
                case .failure(let error):
                    print("TextToImageView: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View
    {
        //MARK: 圖片轉圖片
        List
        {
            ForEach(self.history.indices, id: \.self)
            {index in
                if let data=self.history[index].image,
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
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(.top, index==0 ? 0:5)
                            .padding(.bottom, index==self.history.count-1 ? 0:5)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black))
                    .padding(1)
                    //MARK: 下載按鈕
                    .swipeActions(edge: .leading)
                    {
                        Button
                        {
                            if let data=self.history[index].image,
                               let image=UIImage(data: data)
                            {
                                Task
                                {
                                    await self.saveImage(album: "圖片轉圖片", image: image)
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
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .scrollContentBackground(.hidden)
    }
}
