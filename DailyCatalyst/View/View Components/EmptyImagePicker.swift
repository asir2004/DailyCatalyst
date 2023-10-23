//
//  EmptyImagePicker.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/21/23.
//

import SwiftUI
import PhotosUI

struct EmptyImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    @State private var previewImage: UIImage?
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                    
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .frame(width: size.width, height: size.height)
            .contentShape(.rect)
            .background() {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        }
    }
}
