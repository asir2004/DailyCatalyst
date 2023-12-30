//
//  RectKey.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/6/23.
//

import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
