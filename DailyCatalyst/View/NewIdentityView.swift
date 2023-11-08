//
//  NewIdentityView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/6/23.
//

import SwiftUI
import SymbolPicker

struct NewIdentityView: View {
    var identity: Identity?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var identities: FetchedResults<Identity>
    
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
                
                if identity == nil {
                    Section {
                        ForEach(identities) { identity in
                            HStack {
                                Label(identity.identityName, systemImage: identity.identityIcon)
                                
                                Spacer()
                                
                                Text(identity.identityCreationDateFormatted)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(identity != nil ? "Rename Identity" : "New Identity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $newIdentityIcon)
        }
        .onAppear(perform: {
            if let identity = identity {
                newIdentityName = identity.identityName
                newIdentityIcon = identity.identityIcon
            }
        })
    }
    
    func save() {
        if identity != nil {
            identity!.name = newIdentityName
            identity!.icon = newIdentityIcon
            
            try? viewContext.save()
        } else {
            withAnimation {
                let newIdentity = Identity(context: viewContext)
                newIdentity.id = UUID()
                newIdentity.name = newIdentityName
                newIdentity.icon = newIdentityIcon
                newIdentity.creationDate = .now
                
                try? viewContext.save()
            }
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
    NewIdentityView(identity: .example)
}
