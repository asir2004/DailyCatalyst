//
//  Navigation+Extension.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 9/10/23.
//  This extension is a project by KavSoft on YouTube.
//  https://youtu.be/_oFMZaXIgPc?si=i7qPD9pKMv3GAyXj
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, initial: true, { oldValue, newValue in
                isNavBarHidden = newValue
            })
            .onDisappear(perform: {
                isNavBarHidden = nil
            })
            .background {
                NavigationControllerExtractor(isHidden: isNavBarHidden)
            }
    }
}

private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let hostView = uiView.superview?.superview, let parentController = hostView.parentController {
                if let isHidden {
                    parentController.navigationController?.hidesBarsOnSwipe = isHidden
                }
            }
        }
    }
}

private extension UIView {
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
}

struct Navigation_Extension_Test: View {
    @State private var hideNavBar = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...50, id: \.self) { index in
                    NavigationLink {
                        List {
                            ForEach(1...50, id: \.self) { index in
                                Text("Sub Item \(index)")
                            }
                        }
                        .navigationTitle("Item \(index)")
                    } label: {
                        Text("List Item \(index)")
                    }
                }
            }
            .navigationTitle("Hide NavBar Test List")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        hideNavBar.toggle()
                    } label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    }
                }
            })
            .hideNavBarOnSwipe(true)
        }
    }
}

#Preview {
    Navigation_Extension_Test()
}
