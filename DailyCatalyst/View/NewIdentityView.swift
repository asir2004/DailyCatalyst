//
//  NewIdentityView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/6/23.
//

import SwiftUI

struct NewIdentityView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController
    
    @State private var newIdentityName = ""
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        HStack {
                            Image(systemName: "person")
                            TextField("Identity Name", text: $newIdentityName, prompt: Text("Enter Identity Name Here"))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button("Save") {
                            save()
                            newIdentityName = ""
                        }
                    }
                }
//                Section("Identities") {
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 5) {
//                            ForEach(dataController.allIdentities(), id: \.self) { identity in
//                                Text("\(identity.identityName)")
//                                    .foregroundStyle(.white)
//                                    .padding(5)
//                                    .background(.blue)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                        }
//                    }
//                    //                .onDelete(perform: delete)
//                }
            }
            GeometryReader { geo in
                let cardHeight: CGFloat? = geo.size.height > 0 ? (max(geo.size.height * 0.7, 240) - 40) : nil
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        ForEach(dataController.allIdentities(), id: \.self) { identity in
                            SingleIdentity(identity: identity)
                        }
                    }
                }
                .padding()
                .frame(maxHeight: cardHeight)
            }
        }
        .navigationTitle("New Identity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
    }
    
    private func save() {
        withAnimation {
            let newIdentity = Identity(context: viewContext)
            newIdentity.id = UUID()
            newIdentity.name = newIdentityName
            
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

struct NewIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        NewIdentityView()
    }
}
