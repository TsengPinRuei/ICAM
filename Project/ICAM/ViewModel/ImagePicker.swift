//
//  ImagePicker.swift
//  ICAM
//
//  Created by 曾品瑞 on 2023/8/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View
{
    @State private var loading: Bool=false
    @State private var show: Bool=false
    @State private var photo: PhotosPickerItem?
    @State private var preview: UIImage?
    
    var title: String
    var subtitle: String
    var systemImage: String
    var tint: Color
    var changeImage: (UIImage) -> ()
    
    private func extractImage(_ photo: PhotosPickerItem, _ size: CGSize)
    {
        Task.detached
        {
            guard let image=try? await photo.loadTransferable(type: Data.self) else
            {
                return
            }
            
            await MainActor.run
            {
                if let select=UIImage(data: image)
                {
                    self.generateThumbnail(select, size)
                    self.changeImage(select)
                }
                
                self.photo=nil
            }
        }
    }
    private func generateThumbnail(_ image: UIImage, _ size: CGSize)
    {
        Task.detached
        {
            let thumbnail=await image.byPreparingThumbnail(ofSize: size)
            await MainActor.run
            {
                self.preview=thumbnail
            }
        }
    }
    
    var body: some View
    {
        GeometryReader
        {reader in
            VStack(spacing: 5)
            {
                Image(systemName: self.systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(self.tint)
                
                Text(self.title)
                    .bold()
                    .font(.title)
                    .padding(.top, 15)
                
                Text(self.subtitle)
                    .font(.headline)
                    .foregroundStyle(.black)
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .opacity(self.preview==nil ? 1:0)
            .frame(width: reader.size.width, height: reader.size.height)
            .overlay
            {
                if let preview=self.preview
                {
                    Image(uiImage: preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(5)
                }
            }
            .overlay
            {
                if(self.loading)
                {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                }
            }
            .animation(.bouncy, value: self.loading)
            .animation(.bouncy, value: self.preview)
            .contentShape(.rect(cornerRadius: 10))
            .dropDestination(for: Data.self,
            action:
            {(item, location) in
                if let first=item.first,
                   let drop=UIImage(data: first)
                {
                    self.generateThumbnail(drop, reader.size)
                    self.changeImage(drop)
                    return true
                }
                else
                {
                    return false
                }
            },
            isTargeted:
            {_ in
            })
            .onTapGesture
            {
                self.show.toggle()
            }
            .photosPicker(isPresented: self.$show, selection: self.$photo)
            .optionalViewModifier
            {view in
                view
                    .onChange(of: self.photo)
                    {(_, new) in
                        if let new
                        {
                            self.extractImage(new, reader.size)
                        }
                    }
            }
            .background
            {
                ZStack
                {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(self.tint.opacity(0.1).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(self.tint, style: .init(lineWidth: 3, dash: [12]))
                        .padding(1)
                }
                .shadow(color: self.tint, radius: 5)
            }
        }
    }
}
