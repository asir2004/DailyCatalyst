//
//  CatalystWidgetView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/10/23.
//

import SwiftUI
import WidgetKit

struct CatalystWidgetView: View {
    let catalyst: Catalyst
    
    var body: some View {
        ZStack {
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
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(spacing: 5) {
                                if catalyst.catalystIdentities != [] {
                                    ForEach(catalyst.catalystIdentities, id: \.self) { identity in
                                        Image(systemName: identity.identityIcon)
                                            .imageScale(.small)
                                    }
                                } else {
                                    Image(systemName: "person")
                                        .imageScale(.small)
                                }
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
//                .padding()
            }
//            .frame(height: 200)
            
            Circle()
                .foregroundStyle(.yellow)
                .frame(height: 130)
                .opacity(Double(catalyst.happiness) * 0.1)
                .blur(radius: Double(catalyst.happiness) * 50)
                .frame(alignment: .bottom)
                .offset(y: 70)
        }
        .background {
            if (catalyst.image != nil) {
                if let image = UIImage(data: catalyst.image!) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
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
            }
        }
//        .frame(height: 200)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    CatalystWidgetView(catalyst: .example)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
}
