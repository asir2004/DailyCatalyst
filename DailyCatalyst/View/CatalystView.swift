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
            HStack {
                ImagePicker(catalyst: catalyst, title: "Image Picker", subTitle: "Tap or Drag & Drop", systemImage: "square.and.arrow.down", tint: .blue) { image in
                    print(image)
                }
                .padding(.horizontal)
            }
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
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
                            
                            VStack(alignment: .leading) {
                                Text("Title")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                TextField("Title", text: $catalyst.catalystTitle)
                                    .font(.title)
                            }
                        }
                        
                        Text("**Modification Date:** \(catalyst.catalystModificationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                        
                        Text("**Status:** \(catalyst.catalystStatus)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Picker("Happiness", selection: $catalyst.happiness) {
                        Text("Joy")
                        .tag(Int16(5))
                        
                        Text("Happy")
                        .tag(Int16(4))
                        
                        Text("Apathetic")
                        .tag(Int16(3))
                        
                        Text("Boring")
                        .tag(Int16(2))
                        
                        Text("Exhausted")
                        .tag(Int16(1))
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
