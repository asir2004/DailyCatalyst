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
    var symbolName: String
    var color: Color
    
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedSymbols: [SymbolParticle] = []
    @State private var heartBeat: Int = 85
    var body: some View {
        VStack {
            ZStack {
                if showPulses {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
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
                            if beatAnimation {
                                addPulsedSymbol()
                            }
                        }
                    }
                }
                
                Image(systemName: symbolName)
                    .font(.system(size: 100))
                    .foregroundStyle(color.gradient)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading, content: {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .bottom, spacing: 6) {
                        TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                            Text("\(heartBeat)")
                                .font(.system(size: 45).bold())
                                .contentTransition(.numericText(value: Double(heartBeat)))
                                .foregroundStyle(.white)
                                .onChange(of: timeline.date) { oldValue, newValue in
                                    if beatAnimation {
                                        withAnimation(.bouncy) {
                                            heartBeat = .random(in: 80...130)
                                        }
                                    }
                                }
                        }
                        
                        Text("BPM")
                            .font(.callout.bold())
                            .foregroundStyle(color.gradient)
                    }
                    
                    Text("88 BPM, 10m ago")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .offset(x: 30, y: -35)
            })

            .background(.bar, in: .rect(cornerRadius: 30))
            
            Toggle("Beat Animation", isOn: $beatAnimation)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.top, 20)
                .onChange(of: beatAnimation) { oldValue, newValue in
                    if pulsedSymbols.isEmpty {
                        showPulses = true
                    }
                    
                    if newValue && pulsedSymbols.isEmpty {
                        showPulses = true
                        addPulsedSymbol()
                    }
                }
                .disabled(beatAnimation && pulsedSymbols.isEmpty)
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
            .background(content: {
                Image(systemName: symbolName)
                    .font(.system(size: 100))
                    .foregroundStyle(color.gradient)
                    .blur(radius: 5)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

#Preview {
    AnimatedAwardView(symbolName: "heart.fill", color: .red)
}

