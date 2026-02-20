//
//  OpenAIService.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import Foundation
import SwiftUI
import UIKit
import OpenAIKit

final class OpenAIService : ObservableObject
{
    @AppStorage("APIKey") private var apiKey: String=""
    
    private var openAI: OpenAI?
    
    //MARK: 啟動
    func setUp()
    {
        //連結OpenAI帳號
        //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
        self.openAI=OpenAI(Configuration(organizationId: "Personal", apiKey: ""))
    }
    func editImage(image: UIImage, mask: UIImage, prompt: String, completion: @escaping (UIImage?, Error?) -> Void) async
    {
        guard let openAI=self.openAI
        else
        {
            print("OpenAIService: Account Authorization Error")
            return
        }
        
        do
        {
            let parameter: ImageEditParameters=try ImageEditParameters(image: image, mask: mask, prompt: prompt, numberOfImages: 1, resolution: .large, responseFormat: .base64Json)
            let result=try await openAI.generateImageEdits(parameters: parameter)
            let image=try openAI.decodeBase64Image(result.data[0].image)
            completion(image, nil)
        }
        //生產失敗
        catch
        {
            completion(nil, error)
        }
    }
    //MARK: 文字轉圖片
    func generateImageByText(prompt: String) async -> UIImage?
    {
        //確保帳號連結
        guard let openAI=self.openAI
        else
        {
            print("OpenAIService: Account Authorization Error")
            return nil
        }
        
        do
        {
            //轉換文字為圖片參數
            let parameter: ImageParameters=ImageParameters(prompt: prompt, resolution: .large,responseFormat: .base64Json)
            //AI生產圖片
            let result=try await openAI.createImage(parameters: parameter)
            //回傳第一個AI生產的圖片轉換為64位元圖片檔案
            return try openAI.decodeBase64Image(result.data[0].image)
        }
        //生產失敗
        catch
        {
            print(error.localizedDescription)
            return nil
        }
    }
    //MARK: 圖片轉圖片
    func generaImageByImage(image: UIImage) async -> UIImage?
    {
        //確保帳號連結
        guard let openAI=self.openAI
        else
        {
            print("OpenAIService: Account Authorization Error")
            return nil
        }
        
        do
        {
            //轉換圖片為圖片參數
            let parameter: ImageVariationParameters=try ImageVariationParameters(image: image, resolution: .large, responseFormat: .base64Json)
            //AI生產圖片
            let result=try await openAI.generateImageVariations(parameters: parameter)
            //回傳第一個AI生產的圖片轉換為64位元圖片檔案
            return try openAI.decodeBase64Image(result.data[0].image)
        }
        //生產失敗
        catch
        {
            print(error)
            return nil
        }
    }
}
