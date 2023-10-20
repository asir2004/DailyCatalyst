//
//  NewIdentityView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/6/23.
//

import SwiftUI
import SymbolPicker

struct NewIdentityView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController
    
    @State private var newIdentityName = ""
    @State private var newIdentityIcon = "person"
    
    @State private var iconPickerPresented = false
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
//    @State var items: [String] = ["", ""]
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        HStack {
                            Image(systemName: newIdentityIcon)
                                .onTapGesture {
                                    iconPickerPresented.toggle()
                                }
                            TextField("Identity Name", text: $newIdentityName, prompt: Text("Enter Identity Name Here"))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button("Save") {
                            save()
                            newIdentityName = ""
                            dismiss()
                            feedback.notificationOccurred(.success)
                            
                        }
                        .disabled(newIdentityName.isEmpty)
                    }
                }
            }
            
//            GeometryReader { geo in
//                let cardHeight: CGFloat? = geo.size.height > 0 ? (max(geo.size.height * 0.7, 240) - 40) : nil
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundStyle(.ultraThinMaterial)
//                    HStack {
//                        ForEach(dataController.allIdentities(), id: \.self) { identity in
//                            SingleIdentity(identity: identity)
//                        }
//                    }
//                }
//                .padding()
//                .frame(maxHeight: cardHeight)
//            }
        }
        .navigationTitle("New Identity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $newIdentityIcon)
        }
    }
    
    private func save() {
        withAnimation {
            let newIdentity = Identity(context: viewContext)
            newIdentity.id = UUID()
            newIdentity.name = newIdentityName
            newIdentity.icon = newIdentityIcon
            
            try? viewContext.save()
        }
    }
    
    private func delete(_ offsets: IndexSet) {
        let identities = dataController.allIdentities()
        
        for offset in offsets {
            let item = identities[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    NewIdentityView()
}
