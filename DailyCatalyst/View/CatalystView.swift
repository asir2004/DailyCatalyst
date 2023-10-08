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
    
    @State private var showImagePicker = false
    @State private var photoItem: PhotosPickerItem?
    @State private var imagePickerIsEditing = false
    
    var emoji: String {
        switch catalyst.happiness {
        case 1: return "😐"
        case 2: return "🙂"
        case 3: return "😀"
        case 4: return "😁"
        case 5: return "😆"
        default: return "🥲"
        }
    }
    
    var body: some View {
        VStack(spacing: nil) {
            EmptyImagePicker(catalyst: catalyst, title: "Image Picker", subTitle: "Tap or Drag & Drop", systemImage: "square.and.arrow.down", tint: .yellow, isEditing: imagePickerIsEditing) { image in
                print(image)
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.yellow)
                                    .frame(width: 30)
                                    .opacity(catalyst.happiness <= 1 ? 0 : 1)
                                    .blur(radius: CGFloat(catalyst.happiness == 1 ? 0 : catalyst.happiness * 5))
                                
                                Text("\(emoji)")
                                    .foregroundStyle(catalyst.catalystStatus == "archived" ? .primary : .secondary)
                                    .font(.title)
                            }
                            .zIndex(1)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Title")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                TextEditor(text: $catalyst.catalystTitle)
                                    .font(.title)
                                    .lineLimit(1...2)
                                    .frame(height: 100)
                            }
                        }
                        
                        Text("**Modification Date:** \(catalyst.catalystModificationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                        
                        Text("**Status:** \(catalyst.catalystStatus)")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Section {
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
                    }
                    .padding(.horizontal)
                    
                    Section {
                        VStack(alignment: .leading) {
                            Text("Basic Info")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            
                            TextField("Description", text: $catalyst.catalystEffect, prompt: Text("Enter the effect here"), axis: .vertical)
                        }
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .disabled(catalyst.isDeleted)
        .onReceive(catalyst.objectWillChange) { _ in
            dataController.queueSave()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        imagePickerIsEditing.toggle()
                    }
                } label: {
                    Text(imagePickerIsEditing ? "Done" : "Edit")
                        .monospaced()
                }
                
                Button {
                    
                } label: {
                    Label("Copy catalyst name and description", systemImage: "doc.on.doc")
                }
            }
        }
    }
}

struct CatalystView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystView(catalyst: .example)
    }
}
