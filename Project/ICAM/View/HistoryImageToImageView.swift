//
//  HistoryImageToImgeView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/31.
//

import SwiftUI
import CoreData

struct HistoryImageToImageView: View
{
    @Binding var select: Int
    @Binding var showImage: Bool
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: ImageToImage.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageToImage.time, ascending: true)]
    ) var history: FetchedResults<ImageToImage>
    
    @State private var save: Bool=false
    @State private var sure: Bool=false
    @State private var image: UIImage?
    
    //MARK: 刪除所有CoreData資料
    private func deleteAll()
    {
        do
        {
            let request: NSFetchRequest<ImageToImage>=ImageToImage.fetchRequest()
            let data=try self.context.fetch(request)
            
            for i in data
            {
                self.context.delete(i)
            }
            
            try self.context.save()
        }
        catch
        {
            print("HistoryImageToImageView Delete All Data Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View
    {
        ZStack
        {
            //MARK: 無資料
            if(self.history.isEmpty)
            {
                GradientBackColor().ignoresSafeArea(.all)
                
                Text("去開發小宇宙吧！")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding(.horizontal)
            }
            else
            {
                //MARK: 有資料
                ImageToImageListView(
                    save: self.$save,
                    showImage: self.$showImage,
                    image: self.$image,
                    history: self.history
                )
                //MARK: 注意Alert
                .alert("注意", isPresented: self.$sure)
                {
                    Button("確定", role: .destructive)
                    {
                        withAnimation(.easeInOut)
                        {
                            self.deleteAll()
                        }
                    }
                    
                    Button("取消", role: .cancel) {}
                }
                message:
                {
                    Text("這項操作無法還原")
                }
                //MARK: 成功Alert
                .alert("下載成功", isPresented: self.$save)
                {
                    Button("確認", role: .cancel) {}
                }
                //MARK: Toolbar
                .toolbar
                {
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Button("清空")
                        {
                            self.sure.toggle()
                        }
                    }
                }
            }
            
            //MARK: ImageView
            ImageView(showImage: self.$showImage, image: self.image ?? UIImage())
                .opacity(self.showImage ? 1:0)
        }
    }
}
