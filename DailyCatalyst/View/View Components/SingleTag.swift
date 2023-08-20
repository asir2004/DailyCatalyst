//
//  SingleIdentity.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/18/23.
//

import SwiftUI

struct SingleIdentity: View {
    var identity: Identity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .tint(.blue)
                .foregroundStyle(.thinMaterial)
            Text(identity.identityName)
        }
    }
}

#Preview {
    SingleIdentity(identity: Identity.example)
}
