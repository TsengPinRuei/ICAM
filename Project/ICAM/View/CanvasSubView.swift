//
//  CanvasSubView.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI

struct CanvasSubView<Content: View>: View
{
    @Binding var stack: StackItem
    
    @State private var haptic: CGFloat=1
    
    var content: Content
    var move: () -> ()
    var delete: () -> ()
    
    //MARK: init()
    init(stack: Binding<StackItem>, @ViewBuilder content: @escaping () -> Content, move: @escaping () -> (), delete: @escaping () -> ())
    {
        self._stack=stack
        self.content=content()
        self.move=move
        self.delete=delete
    }
    
    var body: some View
    {
        self.content
            .rotationEffect(self.stack.startRotate)
            .scaleEffect(self.stack.startScale<0.4 ? 0.4:self.stack.startScale)
            .scaleEffect(self.haptic)
            .offset(self.stack.startOffset)
            //MARK: TapGesture
            .gesture(
                TapGesture(count: 2)
                    .onEnded
                    {_ in
                        self.delete()
                    }
                    .simultaneously(
                        with: LongPressGesture(minimumDuration: 0.5)
                            .onEnded
                            {_ in
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                withAnimation(.easeInOut)
                                {
                                    self.haptic=1.2
                                }
                                withAnimation(.easeInOut.delay(0.1))
                                {
                                    self.haptic=1
                                }
                                
                                self.move()
                            }
                    )
            )
            //MARK: DragGesture
            .gesture(
                DragGesture()
                    .onChanged
                    {value in
                        self.stack.startOffset =
                        CGSize(
                            width: self.stack.endOffset.width+value.translation.width,
                            height: self.stack.endOffset.height+value.translation.height
                        )
                    }
                    .onEnded
                    {_ in
                        self.stack.endOffset=self.stack.startOffset
                    }
            )
            //MARK: MagnificationGesture
            .gesture(
                MagnificationGesture()
                    .onChanged
                    {value in
                        self.stack.startScale=self.stack.endScale+(value-1)
                    }
                    .onEnded
                    {_ in
                        self.stack.endScale=self.stack.startScale
                    }
                    .simultaneously(
                        with: RotationGesture()
                            .onChanged
                            {value in
                                self.stack.startRotate=self.stack.endRotate+value
                            }
                            .onEnded
                            {_ in
                                self.stack.endRotate=self.stack.startRotate
                            }
                    )
            )
    }
}
