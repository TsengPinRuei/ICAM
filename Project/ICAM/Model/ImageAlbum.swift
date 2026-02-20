//
//  TextToImageAlbum.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/22.
//

import Photos
import UIKit

class ImageAlbum: NSObject
{
    //static let shared=CustomAlbum()
    
    //相簿名稱
    var name: String="未命名的文字轉圖片"
    private var collection: PHAssetCollection!
    
    //MARK: init
    init(name: String)
    {
        //自定義相簿名稱
        self.name=name
        //繼承原始方法
        super.init()
        //取得圖片集集
        if let collection=self.fetchCollection()
        {
            self.collection=collection
            return
        }
    }
    
    //MARK: 驗證身份
    func checkAuthorization(completion: @escaping(Result<Bool, Error>) -> ())
    {
        if(PHPhotoLibrary.authorizationStatus() == .notDetermined)
        {
            //傳送驗證
            PHPhotoLibrary.requestAuthorization
            {status in
                self.checkAuthorization(completion: completion)
            }
        }
        //驗證成功
        else if(PHPhotoLibrary.authorizationStatus() == .authorized)
        {
            self.createAlbum
            {success in
                completion(success)
            }
        }
        //驗證失敗
        else
        {
            completion(.failure(AlbumError.notAuthorized))
        }
    }
    //MARK: 創建相簿
    private func createAlbum(completion: @escaping (Result<Bool, Error>) -> ())
    {
        //取得圖片集
        if let assetCollection=self.fetchCollection()
        {
            //相簿已經存在
            self.collection=assetCollection
            completion(.success(true))
        }
        //創造圖片集
        else
        {
            PHPhotoLibrary
                .shared()
                //用相簿名稱創造圖片集
                .performChanges({ PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.name) })
                {(success, error) in
                    //創造失敗
                    if let error=error
                    {
                        completion(.failure(error))
                    }
                    
                    //創造成功
                    if(success)
                    {
                        self.collection=self.fetchCollection()
                        completion(.success(true))
                    }
                    //創造相簿失敗
                    else
                    {
                        completion(.success(false))
                    }
                }
        }
    }
    //MARK: 抓取圖片集
    private func fetchCollection() -> PHAssetCollection?
    {
        //抓取的設定
        let fetchOption=PHFetchOptions()
        //格式化規則
        fetchOption.predicate=NSPredicate(format: "title=%@", self.name)
        //抓取圖片集
        let collection=PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOption)
        
        //取得第一個圖片
        if let _: AnyObject=collection.firstObject
        {
            //回傳抓取到的第一個物件
            return collection.firstObject
        }
        return nil
    }
    //MARK: 儲存圖片
    func save(image: UIImage, completion: @escaping (Result<Bool, Error>) -> ())
    {
        //驗證身份
        self.checkAuthorization
        {result in
            switch(result)
            {
                //驗證成功
                case .success(let success):
                    //驗證成功 && 存在圖片集
                    if(success && self.collection != nil)
                    {
                        PHPhotoLibrary
                            .shared()
                            .performChanges({
                                let changeRequest=PHAssetChangeRequest.creationRequestForAsset(from: image)
                                let placeHolder=changeRequest.placeholderForCreatedAsset
                                if let albumChangeRequest=PHAssetCollectionChangeRequest(for: self.collection)
                                {
                                    let enumeration: NSArray=[placeHolder!]
                                    albumChangeRequest.addAssets(enumeration)
                                }},
                                completionHandler: {(success, error) in
                                    if let error=error
                                    {
                                        print("Custom Album: 寫進相簿錯誤：\(error.localizedDescription)")
                                        completion(.failure(error))
                                        return
                                    }
                                    completion(.success(success))
                                }
                            )
                        
                    }
                //驗證失敗
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
}
