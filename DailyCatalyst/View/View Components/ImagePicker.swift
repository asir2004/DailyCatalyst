//
//  ImagePicker.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/21/23.
//

import SwiftUI
import PhotosUI
import CoreData

struct ImagePicker: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var isEditing: Bool
    var onImageChange: (UIImage) -> ()
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?
    
    @State private var previewImage: UIImage?
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let scaledSize = CGSize(width: size.width * 2, height: size.height * 2)
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            /// Displaying Preview Image, if any
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(isEditing ? 15 : 0)
                }
            }
            /// Displaying Loading UI
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// Animating Changes
            .animation(.snappy, value: isLoading)
            .animation(.snappy, value: previewImage)
            .contentShape(.rect)
            /// Implementing Drop Action and Retriving Dropped Image
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    /// Sending the Image using the callback
                    generateImageThumbnail(droppedImage, scaledSize)
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                if isEditing {
                    showImagePicker.toggle()
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .optionalViewModifier { contentView in
                if #available(iOS 17, *) {
                    contentView
                        .onChange(of: photoItem) { oldValue, newValue in
                            if let newValue {
                                extractImage(newValue, scaledSize)
                            }
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    photoData = data
                                    catalyst.image = photoData
                                    dataController.queueSave()
                                }
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem) { newValue in
                            if let newValue {
                                extractImage(newValue, scaledSize)
                            }
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    photoData = data
                                    catalyst.image = photoData
                                    dataController.queueSave()
                                }
                            }
                        }
                }
            }
            .background() {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
                .opacity(isEditing ? 1 : 0)
            }
            .onAppear() {
                if (catalyst.image != nil) {
                    if let image = UIImage(data: catalyst.image!) {
                        generateImageThumbnail(image, scaledSize)
                        onImageChange(image)
                    }
                }
            }
        }
    }
    
    func extractImage(_ photoItem: PhotosPickerItem, _ viewSize: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else {
                return
            }
            
            // UI must be updated on Main Thread
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    generateImageThumbnail(selectedImage, viewSize)
                    onImageChange(selectedImage)
                }
                
                self.photoItem = nil
            }
        }
    }
    
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            /// UI must be updated on Main Thread
            await MainActor.run {
                previewImage = thumbnailImage
            }
        }
    }
}

extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

#Preview {
    ImagePicker(catalyst: .example, title: "Image Picker", subTitle: "Tap or Drag & Drop", systemImage: "square.and.arrow.up", tint: .blue, isEditing: true) { image in
        print(image)
    }
}
