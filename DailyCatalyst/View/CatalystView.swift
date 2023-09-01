//
//  CatalystView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct CatalystView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        VStack(spacing: nil) {
            HStack {
                EmojiCard(happiness: Int(catalyst.happiness))
                
                ImagePicker(title: "Image Picker", subTitle: "Tap or Drag & Drop", systemImage: "square.and.arrow.down", tint: .blue) { image in
                    print(image)
                }
                .padding(.horizontal)
            }
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Title")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $catalyst.catalystTitle)
                            .font(.title)
                            .lineLimit(3)
                        
                        Text("**Modification Date:** \(catalyst.catalystModificationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                        
                        Text("**Status:** \(catalyst.catalystStatus)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Picker("Happiness", selection: $catalyst.happiness) {
                        HStack {
                            Text("Joy")
                            Spacer()
                            Text("😆")
                        }
                        .tag(Int16(5))
                        
                        HStack {
                            Text("Happy")
                            Spacer()
                            Text("😁")
                        }
                        .tag(Int16(4))
                        
                        HStack {
                            Text("Apathetic")
                            Spacer()
                            Text("😀")
                        }
                        .tag(Int16(3))
                        
                        HStack {
                            Text("Boring")
                            Spacer()
                            Text("🙂")
                        }
                        .tag(Int16(2))
                        
                        HStack {
                            Text("Exhausted")
                            Spacer()
                            Text("😐")
                        }
                        .tag(Int16(1))
                    }
                    
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
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Basic Info")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        TextField("Description", text: $catalyst.catalystEffect, prompt: Text("Enter the effect here"), axis: .vertical)
                    }
                }
            }
        }
        .disabled(catalyst.isDeleted)
        .onReceive(catalyst.objectWillChange) { _ in
            dataController.queueSave()
        }
    }
}

struct CatalystView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystView(catalyst: .example)
    }
}
