# ICAM

ICAM 是一個以 SwiftUI 開發的 iOS AI 影像應用，提供文字生成圖片、圖片生成圖片、相機拍照與歷史紀錄等功能。

## 功能

- 文字轉圖片（Text-to-Image）
- 圖片轉圖片（Image-to-Image）
- 影像編輯（含遮罩編修流程）
- 相簿儲存與系統分享
- Core Data 歷史紀錄
- 多種視覺風格與預設效果

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
2. 選擇模擬器或實機
3. 在 `Project/ICAM/Model/OpenAIService.swift` 設定自己的 OpenAI API Key
4. Build & Run

## 安全建議

請勿把實際 API Key 提交到版本控制。建議改用本機設定檔或 Keychain 管理金鑰。
