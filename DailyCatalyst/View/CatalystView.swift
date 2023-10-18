//
//  CatalystView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI
import PhotosUI

struct CatalystView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    @State private var imagePickerIsEditing = false
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            List {
                Section("Image") {
                    ImagePicker(catalyst: catalyst, title: "Image Picker", subTitle: "Tap or Drag & Drop", systemImage: "square.and.arrow.down", tint: .yellow, isEditing: imagePickerIsEditing) { image in
                        print(image)
                    }
                    .frame(height: 300)
                }
                
                Section {
                    HStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .foregroundStyle(.yellow)
                                .frame(width: 30)
                                .opacity(catalyst.happiness <= 1 ? 0 : 1)
                                .blur(radius: CGFloat(catalyst.happiness == 1 ? 0 : catalyst.happiness * 5))
                            
                            Text("\(emojiFromHappiness(happiness: Int(catalyst.happiness)))")
                                .foregroundStyle(catalyst.catalystStatus == "archived" ? .primary : .secondary)
                                .font(.title)
                        }
                        .zIndex(1)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Title")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            TextField("Title Here", text: $catalyst.catalystTitle)
                                .font(.title)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("**Modification Date:** \(catalyst.catalystModificationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                        
                        Text("**Status:** \(catalyst.catalystStatus)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Picker("Happiness", selection: $catalyst.happiness) {
                        Text("😐")
                            .tag(Int16(1))
                        
                        Text("🙂")
                            .tag(Int16(2))
                        
                        Text("😀")
                            .tag(Int16(3))
                        
                        Text("😁")
                            .tag(Int16(4))
                        
                        Text("😆")
                            .tag(Int16(5))
                    }
                    .pickerStyle(.segmented)
                    
                    Menu {
                        ForEach(catalyst.catalystIdentities, id: \.self) { identity in
                            Button {
                                catalyst.removeFromIdentities(identity)
                            } label: {
                                Label(identity.identityName, systemImage: "checkmark")
                            }
                        }
                        
                        let otherIdentities = dataController.missingIdentities(from: catalyst)
                        
                        if otherIdentities.isEmpty == false {
                            Divider()
                            
                            Section("Add Identities") {
                                ForEach(otherIdentities) { identity in
                                    Button(identity.identityName) {
                                        catalyst.addToIdentities(identity)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(catalyst.catalystIdentitiesList)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(nil, value: catalyst.catalystIdentitiesList)
                    }
                    
                    TextField("Description", text: $catalyst.catalystEffect, prompt: Text("Enter the effect here"), axis: .vertical)
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .disabled(catalyst.isDeleted)
            .onReceive(catalyst.objectWillChange) { _ in
                dataController.queueSave()
            }
            .toolbar {
                CatalystViewToolbar(catalyst: catalyst, imagePickerIsEditing: $imagePickerIsEditing)
            }
        }
    }
}

#Preview {
    CatalystView(catalyst: .example)
}
