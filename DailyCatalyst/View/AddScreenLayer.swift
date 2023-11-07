//
//  AddScreenLayer.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/7/23.
//

import SwiftUI

struct ExampleIcon: View {
    @State public var icon: String

    internal init(icon: String, action: (() -> Void)? = nil) {
        self.icon = icon
    }

    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .scaleEffect(0.416)
                .foregroundColor(Color(.systemGray))
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }
}

struct LayerButton: View {
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper

    @Binding var text: String
    @Binding var icon: String

    @State var id: Int
    @State var background: Color
    @State var disabled: Bool
    @State var foregroundColor: Color? = nil
    @State var pressed = false
    @State var action: () -> Void

    internal init(
        id: Int = Int.random(in: 1 ..< 100000000),
        text: Binding<String> = .constant("Confirm"),
        icon: Binding<String> = .constant("checkmark.circle"),
        background: Color = Color(.systemBlue),
        foregroundColor: Color? = nil,
        disabled: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.id = id
        self._text = text
        self._icon = icon
        self.action = action
        self.background = background
        self.foregroundColor = foregroundColor
        self.disabled = disabled
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                HStack(alignment: .center, spacing: 4) {
                    if icon != "" {
                        Image(systemName: icon)
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .contrastTextColor(background: background, foregroundColor: foregroundColor)
                            .transition(.opacity)
                            .matchedGeometryEffect(
                                id: "layer.button.icon.\(id)",
                                in: namespaceWrapper.namespace
                            )
                    }

                    Text(text)
                        .contrastTextColor(background: background, foregroundColor: foregroundColor)
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .transition(.scale(scale: 1.0))
                        .matchedGeometryEffect(
                            id: "layer.button.text.\(id)",
                            in: namespaceWrapper.namespace
                        )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(disabled ? background.opacity(0.5) : background.opacity(1.0))
            .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
            .scaleEffect(pressed ? 0.85 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: pressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        pressed = true
                    }
                    .onEnded { _ in
                        pressed = false
                        action()
                    }
            )
        }
    }
}

struct AddScreenWelcomeHeader: View {
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper

    var body: some View {
        HStack {
            ExampleIcon(icon: "questionmark")
                .matchedGeometryEffect(
                    id: "layer.icon.left",
                    in: namespaceWrapper.namespace
                )

            FullWidthText(center: true) {
                Text("Welcome to Add Screen")
                    .fixedSize()
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .transition(.scale(scale: 1.0))
                    .matchedGeometryEffect(
                        id: "layer.header",
                        in: namespaceWrapper.namespace
                    )
            }

            ExampleIcon(icon: "xmark")
                .matchedGeometryEffect(
                    id: "layer.icon.right",
                    in: namespaceWrapper.namespace
                )
        }
    }
}

struct AddScreenWelcome: View {
    var body: some View {
        Text("Hello World!")
    }
}

struct NewCatalystViewHeader: View {
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper

    var body: some View {
        HStack {
            ExampleIcon(icon: "questionmark")
                .matchedGeometryEffect(
                    id: "layer.icon.left",
                    in: namespaceWrapper.namespace
                )

            FullWidthText(center: true) {
                Text("Add Catalyst")
                    .fixedSize()
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .transition(.scale(scale: 1.0))
                    .matchedGeometryEffect(
                        id: "layer.header",
                        in: namespaceWrapper.namespace
                    )
            }

            ExampleIcon(icon: "xmark")
                .matchedGeometryEffect(
                    id: "layer.icon.right",
                    in: namespaceWrapper.namespace
                )
        }
    }
}

struct NewIdentityViewHeader: View {
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper

    var body: some View {
        HStack {
            ExampleIcon(icon: "questionmark")
                .matchedGeometryEffect(
                    id: "layer.icon.left",
                    in: namespaceWrapper.namespace
                )

            FullWidthText(center: true) {
                Text("Add Identity")
                    .fixedSize()
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .transition(.scale(scale: 1.0))
                    .matchedGeometryEffect(
                        id: "layer.header",
                        in: namespaceWrapper.namespace
                    )
            }

            ExampleIcon(icon: "xmark")
                .matchedGeometryEffect(
                    id: "layer.icon.right",
                    in: namespaceWrapper.namespace
                )
        }
    }
}

struct AddScreenLayer: View {
    @Bindable var layers: LayerModel = .init(
        index: 0,
        max: 3,
        headers: [
            0: AnyView(AddScreenWelcomeHeader()),
            1: AnyView(NewCatalystViewHeader()),
            2: AnyView(NewIdentityViewHeader()),
        ],
        contents: [
            0: AnyView(AddScreenWelcome()),
            1: AnyView(NewCatalystView()),
            2: AnyView(NewIdentityViewHeader()),
        ],
        buttons: [
            0: [["Catalyst": "flask"], ["Identity": "person"]],
            1: [["Save": "checkmark"], ["Save": "checkmark"]],
            2: [["Save": "checkmark"], ["Save": "checkmark"]],
        ]
    )
    
    var body: some View {
        Layer {
            layers.getCurrentHeader()
                .id("layer.stack.header.\(layers.index)")

            layers.getCurrentContent()
                .id("layer.stack.content.\(layers.index)")
                .frame(height: 200)

            HStack {
                switch layers.index {
                case 0: Group {
                    LayerButton(
                        text: Binding.constant(layers.getCurrentButtons()[0].keys.first ?? ""),
                        icon: Binding.constant(layers.getCurrentButtons()[0].values.first ?? ""),
                        background: .blue) {
                            layers.set(index: 1)
                        }
                    
                    LayerButton(
                        text: Binding.constant(layers.getCurrentButtons()[1].keys.first ?? ""),
                        icon: Binding.constant(layers.getCurrentButtons()[1].values.first ?? ""),
                        background: .orange) {
                            layers.set(index: 2)
                        }
                }
                    
                case 1: Group {
                    LayerButton(
                        text: Binding.constant(layers.getCurrentButtons()[0].keys.first ?? ""),
                        icon: Binding.constant(layers.getCurrentButtons()[0].values.first ?? ""),
                        background: .blue) {
                            NewCatalystView().save()
                        }
                }
                    
                case 2: Group {
                    LayerButton(
                        text: Binding.constant(layers.getCurrentButtons()[0].keys.first ?? ""),
                        icon: Binding.constant(layers.getCurrentButtons()[0].values.first ?? ""),
                        background: .yellow) {
                            NewIdentityView().save()
                        }
                }
                    
                default: Group{
                    
                }
                }
            }
        }
    }
}

#Preview {
    AddScreenLayer()
}
