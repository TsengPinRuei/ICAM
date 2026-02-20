//
//  PrestyleView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/11/25.
//

import SwiftUI

struct PrestyleView: View
{
    @Binding var setPrestyle: [(String, String)]
    
    private let prestyle: [(String, String)]=ImageStyle().prestyle
    
    //MARK: 檢查品質風格
    private func prestyleContains(index: Int) -> Bool
    {
        for i in self.setPrestyle
        {
            if(i.0==self.prestyle[index].0 && i.1==self.prestyle[index].1)
            {
                return true
            }
        }
        return false
    }
    //MARK: 刪除品質風格
    private func prestyleRemove(index: Int)
    {
        for i in 0..<self.setPrestyle.count
        {
            if(self.setPrestyle[i].0==self.prestyle[index].0 && self.setPrestyle[i].1==self.prestyle[index].1)
            {
                self.setPrestyle.remove(at: i)
                return
            }
        }
    }
    
    var body: some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            HStack(spacing: 20)
            {
                ForEach(0..<self.prestyle.count, id: \.self)
                {index in
                    Text(self.prestyle[index].0)
                        .font(.title3)
                        .foregroundStyle(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.prestyleContains(index: index) ? Color(.systemGray4):Color.clear)
                        .clipShape(Capsule())
                        .onTapGesture
                        {
                            if(!self.prestyleContains(index: index))
                            {
                                self.setPrestyle.append((self.prestyle[index].0, self.prestyle[index].1))
                            }
                            else
                            {
                                self.prestyleRemove(index: index)
                            }
                        }
                }
            }
            .padding(5)
        }
    }
}
