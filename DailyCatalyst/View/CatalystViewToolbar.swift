//
//  CatalystViewToolbar.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/9/23.
//

import SwiftUI

struct CatalystViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    @Binding var imagePickerIsEditing: Bool
    
    var body: some View {
        Button {
            UIPasteboard.general.string = catalyst.catalystTitle + " " + catalyst.catalystEffect
        } label: {
            Label("Copy catalyst title and effect", systemImage: "doc.on.doc")
        }
        
        Button {
            withAnimation {
                imagePickerIsEditing.toggle()
            }
        } label: {
            Text(imagePickerIsEditing ? "Done" : "Edit")
                .monospaced()
        }
    }
}

#Preview {
    CatalystViewToolbar(catalyst: .example, imagePickerIsEditing: .constant(false))
}
