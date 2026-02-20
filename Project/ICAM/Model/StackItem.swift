//
//  StackItem.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/9/22.
//

import SwiftUI

struct StackItem: Identifiable
{
    var id: String=UUID().uuidString
    var view: AnyView
    var startOffset: CGSize = .zero
    var endOffset: CGSize = .zero
    var startScale: CGFloat=1
    var endScale: CGFloat=1
    var startRotate: Angle = .zero
    var endRotate: Angle = .zero
}
