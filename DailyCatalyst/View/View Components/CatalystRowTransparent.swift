//
//  CatalystRowTransparent.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/18/23.
//

import SwiftUI

struct CatalystRowTransparent: View {
    @ObservedObject var catalyst: Catalyst
    @EnvironmentObject var dataController: DataController
    
    @AppStorage("cardPictureHeight") var cardWithPictureHeight = 200
    @AppStorage("cardPlainHeight") var cardPlainHeight = 150
    
    var width: CGFloat
    var isEditing: Bool
    var isSelected: Binding<Bool>
    
    var body: some View {
        NavigationLink(destination: CatalystView(catalyst: catalyst)) {
            ZStack {
                if isEditing {
                    Button {
                        isSelected.wrappedValue.toggle()
                    } label: {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundStyle(isSelected.wrappedValue ? .blue : .white)
                    }
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    
                if (catalyst.image != nil) {
                    if let image = UIImage(data: catalyst.image!) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: abs(width - 20))
                            .clipped()
                            .mask(RadialGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .black.opacity(0.5), location: 0),
                                    .init(color: .clear, location: 1)
                                ]),
                                center: .bottomTrailing,
                                startRadius: 0,
                                endRadius: 200
                            ))
                            .frame(alignment: .bottomTrailing)
                    }
                } else {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text(emojiFromHappiness(happiness: Int(catalyst.happiness)))
                                .font(.system(size: 100))
                                .mask(LinearGradient(gradient: Gradient(stops: [
                                    .init(color: .black.opacity(0.2), location: 0),
                                    .init(color: .clear, location: 1),
                                    .init(color: .black, location: 1),
                                    .init(color: .clear, location: 1)
                                ]), startPoint: .trailing, endPoint: .leading))
                        }
                    }
                }
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                if catalyst.catalystIdentities != [] {
                                    ForEach(catalyst.catalystIdentities, id: \.self) { identity in
                                        Image(systemName: identity.identityIcon)
                                            .imageScale(.small)
                                    }
                                } else {
                                    Image(systemName: "person")
                                        .imageScale(.small)
                                }
                                
                                Text(catalyst.catalystIdentitiesList)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .italic(catalyst.catalystIdentities == [])
                            }
                            
                            Text(catalyst.catalystTitle)
                                .font(.title2)
                                .lineLimit(2)
                            Text(catalyst.catalystEffect)
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(catalyst.catalystHappeningDate.formatted(date: .numeric, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(height: catalyst.image != nil ? CGFloat(cardWithPictureHeight) : CGFloat(cardPlainHeight))
                
                Circle()
                    .foregroundStyle(.yellow)
                    .frame(height: 130)
                    .opacity(Double(catalyst.happiness) * 0.1)
                    .blur(radius: Double(catalyst.happiness) * 50)
                    .frame(alignment: .bottom)
                    .offset(y: 70)
            }
            .frame(height: catalyst.image != nil ? CGFloat(cardWithPictureHeight) : CGFloat(cardPlainHeight))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contextMenu(
                menuItems: {
                    Button {
                        catalyst.archived.toggle()
                    } label: {
                        Label(catalyst.archived ? "Mark Open" : "Archive", systemImage: catalyst.archived ? "envelope.open" : "envelope")
                            .tint(catalyst.archived ? .blue : .red)
                    }
                    
                    Button(role: .destructive) {
                        withAnimation {
                            dataController.delete(catalyst)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CatalystRowTransparent(catalyst: .example, width: 200, isEditing: true, isSelected: Binding.constant(true))
}
