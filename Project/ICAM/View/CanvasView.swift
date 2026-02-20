//
//  CanvasView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI

struct CanvasView: View
{
    @EnvironmentObject var canvas: Canvas
    
    var height: CGFloat=400
    
    //MARK: 取得Stack索引值
    private func getStackIndex(stack: StackItem) -> Int
    {
        return self.canvas.stack.firstIndex {index in   return index.id==stack.id } ?? 0
    }
    //MARK: 將指定StackItem移動到Stack頂部
    private func moveViewToFront(stack: StackItem)
    {
        let current: Int=self.getStackIndex(stack: stack)
        let end: Int=self.canvas.stack.count-1
        self.canvas.stack.insert(self.canvas.stack.remove(at: current), at: end)
    }
    
    var body: some View
    {
        GeometryReader
        {reader in
            let size=reader.size
            
            ZStack
            {
                Color.gray.opacity(0.5)
                
                ForEach(self.$canvas.stack)
                {$index in
                    //MARK: CanvasSubView
                    CanvasSubView(stack: $index)
                    {
                        index.view
                    }
                    move:
                    {
                        self.moveViewToFront(stack: index)
                    }
                    delete:
                    {
                        self.canvas.current=index
                        self.canvas.showDelete.toggle()
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(height: self.height)
        .clipped()
        //MARK: Alert
        .alert("確定要刪除嗎？\n該操作不能還原。", isPresented: self.$canvas.showDelete)
        {
            Button("取消", role: .cancel) {}
            
            if let current=self.canvas.current
            {
                Button("確定", role: .destructive)
                {
                    self.canvas.stack.remove(at: self.getStackIndex(stack: current))
                }
                .disabled(current.id=="MASKRECTANGLE")
            }
        }
    }
}
