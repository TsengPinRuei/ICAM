//
//  HistoryTextToImageView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/31.
//

import SwiftUI
import CoreData

struct HistoryTextToImageView: View
{
    @Binding var searchText: String
    @Binding var showLanguage: Bool
    @Binding var language: Int
    @Binding var select: Int
    @Binding var showImage: Bool
    
    //要在context之前
    @Environment(\.isSearching) private var isSearching
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: TextToImage.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TextToImage.time, ascending: true)]
    ) var history: FetchedResults<TextToImage>
    
    @State private var save: Bool=false
    @State private var sure: Bool=false
    @State private var image: UIImage?
    
    //MARK: 刪除所有CoreData資料
    private func deleteAll()
    {
        do
        {
            let request: NSFetchRequest<TextToImage>=TextToImage.fetchRequest()
            let data=try self.context.fetch(request)
            
            for i in data
            {
                self.context.delete(i)
            }
            
            try self.context.save()
        }
        catch
        {
            print("HistoryTextToImageView Delete All Data Error: \(error.localizedDescription)")
        }
    }
    
    //MARK: init
    init(
        searchText: Binding<String>,
        showLanguage: Binding<Bool>,
        language: Binding<Int>,
        select: Binding<Int>,
        showImage: Binding<Bool>
    )
    {
        self._searchText=searchText
        self._showLanguage=showLanguage
        self._language=language
        self._select=select
        self._showImage=showImage
        
        //MARK: 搜尋列設定
        let textField=UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        
        textField.backgroundColor = UIColor.systemGray6
        textField.tintColor = .black
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
            //MARK: 有資料
            else
            {
                //MARK: TextToImageListView
                TextToImageListView(
                    showImage: self.$showImage,
                    save: self.$save,
                    sure: self.$sure,
                    image: self.$image,
                    history: self.history
                )
                //MARK: 注意Alert
                .alert("你確定嗎", isPresented: self.$sure)
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
            
            //MARK: 完整圖片
            ImageView(showImage: self.$showImage, image: self.image ?? UIImage()).opacity(self.showImage ? 1:0)
        }
        //MARK: 搜尋狀態
        .onChange(of: self.isSearching)
        {(_, new) in
            withAnimation(.easeInOut)
            {
                self.showLanguage=new ? true:false
            }
        }
        //MARK: 搜尋結果
        .onChange(of: self.searchText)
        {(_, new) in
            var predicate: NSPredicate
            
            if(self.searchText.isEmpty)
            {
                predicate=NSPredicate(value: true)
            }
            
            else
            {
                predicate=NSPredicate(format: "textC CONTAINS[c] %@ OR textE CONTAINS[c] %@", new, new)
            }
            
            self.history.nsPredicate=predicate
        }
    }
}
