//
//  View+Extension.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/6/23.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
