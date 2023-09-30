//
//  AnimatedAwardView.swift
//  DailyCatalyst
//
//  From Heart Animation on Apple Watch
//  Followed the tutorial from @KavSoft
//
//  Created by Asir Bygud on 9/28/23.
//

import SwiftUI

struct SymbolParticle: Identifiable {
    var id: UUID = .init()
}

struct AnimatedAwardView: View {
    var awardName: String
    var awardDescription: String
    var symbolName: String
    var color: Color
    
    @State private var showPulses: Bool = true
    @State private var pulsedSymbols: [SymbolParticle] = []
    
    var body: some View {
        VStack {
            ZStack {
                if showPulses {
                    TimelineView(.animation(minimumInterval: 1.4, paused: false)) { timeline in
                        Canvas { context, size in
                            for symbol in pulsedSymbols {
                                if let resolvedView = context.resolveSymbol(id: symbol.id) {
                                    let centerX = size.width / 2
                                    let centerY = size.height / 2
                                    
                                    context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
                                }
                            }
                        } symbols: {
                            ForEach(pulsedSymbols) {
                                PulseSymbolView(symbolName: symbolName, color: color)
                                    .id($0.id)
                            }
                        }
                        .onChange(of: timeline.date) { oldValue, newValue in
                            addPulsedSymbol()
                        }
                    }
                }
                
                Image(systemName: symbolName)
                    .font(.system(size: 100))
                    .foregroundStyle(color.gradient)
                    .background(
                        Circle()
                            .stroke(.thinMaterial, lineWidth: 16)
                            .stroke(.ultraThinMaterial, lineWidth: 8)
                            .fill(.regularMaterial)
                            .padding(-25)
                    )
                    .symbolEffect(.bounce.down, options: .repeating.speed(0.5), value: pulsedSymbols.count)
            }
            .offset(y: 40)
            .frame(maxWidth: 350, maxHeight: 450)
            .overlay(alignment: .topLeading, content: {
                VStack(alignment: .leading, spacing: 5) {
                    Text(awardName)
                        .font(.title)
                        .bold()
                    Text(awardDescription)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .offset(x: 30, y: 25)
            })
            .background(.bar, in: .rect(cornerRadius: 30))
            
//            Toggle("Beat Animation", isOn: $beatAnimation)
//                .padding(15)
//                .frame(maxWidth: 350)
//                .background(.bar, in: .rect(cornerRadius: 15))
//                .padding(.top, 20)
//                .onChange(of: beatAnimation) { oldValue, newValue in
//                    if pulsedSymbols.isEmpty {
//                        showPulses = true
//                    }
//
//                    if newValue && pulsedSymbols.isEmpty {
//                        showPulses = true
//                        addPulsedSymbol()
//                    }
//                }
        }
    }
    
    func addPulsedSymbol() {
        let pulsedSymbol = SymbolParticle()
        pulsedSymbols.append(pulsedSymbol)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedSymbols.removeAll(where: { $0.id == pulsedSymbol.id })
            
            if pulsedSymbols.isEmpty {
                showPulses = false
            }
        }
    }
}

struct PulseSymbolView: View {
    var symbolName: String
    var color: Color
    
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: 100))
            .foregroundStyle(color)
            .blur(radius: 5)
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.3)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

#Preview {
    AnimatedAwardView(awardName: "Sample Award Name", awardDescription: "A preview sample award description.", symbolName: "heart.fill", color: .red)
}
