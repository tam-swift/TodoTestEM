//
//  View.swift
//  TestEM
//
//  Created by Tamerlan Swift on 28.10.2025.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow {
                placeholder()
            }
        }
        .allowsHitTesting(false)
    }
}
