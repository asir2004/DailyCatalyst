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
        VStack {
            EmojiCard(happiness: catalyst.happiness)
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Title", text: $catalyst.catalystTitle, prompt: Text("Enter Title Here"))
                            .font(.title)
                        
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
                        ForEach(catalyst.catalystTags, id: \.self) { tag in
                            Button {
                                catalyst.removeFromTags(tag)
                            } label: {
                                Label(tag.tagName, systemImage: "checkmark")
                            }
                        }
                        
                        let otherTags = dataController.missingTags(from: catalyst)
                        
                        if otherTags.isEmpty == false {
                            Divider()
                            
                            Section("Add Tags") {
                                ForEach(otherTags) { tag in
                                    Button(tag.tagName) {
                                        catalyst.addToTags(tag)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(catalyst.catalystTagsList)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(nil, value: catalyst.catalystTagsList)
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
