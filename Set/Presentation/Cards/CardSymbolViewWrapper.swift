//
//  CardSymbolViewWrapper.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI

/// Wraps CardSymbolView for SwiftUI
@available(iOS 13.0, *)
struct CardSymbolViewWrapper: UIViewRepresentable {
    let card: Card

    func makeUIView(context: Context) -> CardSymbolView {
        CardSymbolView(frame: .zero, card: card)
    }

    func updateUIView(_ uiView: CardSymbolView, context: Context) {
        // Do nothing
    }
}
