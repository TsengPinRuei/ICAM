//
//  ImageStyle.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/24.
//

import Foundation
import SwiftUI

struct ImageStyle
{
    let image: [ImageResource]=[.realism, .fantasy, .visual, .lightingShadow, .cyberpunk, .modern, .handdraw, .colorPencil, .charcoal, .pastel, .ink, .watercolor, .oil, .abstract, .cartoon, .animation, .graphic, .cubist, .impression, .digital]
    let prestyle: [(String, String)]=[("平滑", "Smooth"), ("清晰聚焦", "Sharp focus"), ("磨砂", "matte"), ("高雅", "elegant"), ("8K", "8K"), ("鋭化", "Sharp"), ("史詩", "Epic composition"), ("大氣層粒子特效", "Atmospheric"), ("宏大畫面", "Upscaled"), ("電影", "Cinematic"), ("明亮", "Bright"), ("柔光", "Soft light"), ("美麗", "The most beautiful image ever seen"), ("高細節", "Technique highly detailed"), ("夢想", "Dreamatic lighting"), ("環境", "Ambient"), ("超廣角", "Ultrawide"), ("海報", "Wallpaper"), ("光線追蹤", "Raytracing reflections"), ("3D無光繪畫", "3D matte painting"), ("氛圍光", "Mood lighting"), ("全局柔光燈", "Soft illumination"), ("閃光", "Rays of shimmering light"), ("生物光", "Bioluminescence")]
    let style: [(String, String)]=[("現實", "Realism"), ("幻想", "Fantasy visual effects"), ("視覺", "Visual effects"), ("光影", "Lighting and shadow visual effects"), ("賽博龐克", "Cyberpunk"), ("現代畫", "Modern"), ("手繪", "Hand-drawn style visual effects"), ("彩鉛筆畫", "Color pencil drawing"), ("碳筆畫", "Charcoal drawing"), ("粉彩畫", "Pastel painting"), ("紙本水墨畫", "Paper-based ink wash painting"), ("水彩畫", "Watercolor painting"), ("油畫", "Oil painting"), ("抽像畫", "Abstract"), ("黑白卡通", "Black and white cartoon"), ("黑白動畫", "Black and white animation"), ("平面設計", "Graphic design"), ("立體", "Cubist"), ("印象", "Impressionist"), ("數位", "Digital painting style visual effects")]
}
