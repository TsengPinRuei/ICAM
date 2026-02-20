# ICAM

這份專案是 2024 大學畢業專題，以 SwiftUI 開發的 iOS 應用程式，可能會語法過時、版本過舊等問題，需要再進行更新。

## 功能

- 文字轉圖片
- 圖片轉圖片
- 影像編輯（含遮罩編輯）
- 相簿儲存與系統分享
- Core Data 歷史紀錄
- 多樣化的視覺風格與效果

## 技術與相依套件

- Swift 5
- SwiftUI
- Core Data
- [OpenAIKit](https://github.com/MarcoDotIO/OpenAIKit)
- [SwiftUICharts](https://github.com/AppPear/ChartView)

## 專案結構

- `Project/ICAM/`: iOS App 原始碼
- `Project/ICAM.xcodeproj/`: Xcode 專案檔
- `Document/`: 專案文件（SRS、SDD、SUM、Introduction）

## 環境需求

- Xcode 15+
- iOS 17.0+

## 如何執行

1. 使用 Xcode 開啟 `Project/ICAM.xcodeproj`
2. 選擇模擬器或實機（本專案使用 iPhone 14 Pro）
3. 在 `Project/ICAM/Model/OpenAIService.swift` 設定自己的 OpenAI API Key
4. Build & Run
