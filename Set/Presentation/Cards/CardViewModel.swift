//
//  CardViewModel.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI
import Swinject
import Yoyo

@available(iOS 13.0, *)
class CardViewModel: ObservableObject {
    private let game: GameManagerProtocol

    let card: Card
    @Published private(set) var borderColor = Color.gray
    @Published private(set) var borderWidth: CGFloat = 1

    private let isSelected = StoredProperty(false)

    private let updater = YoyoUpdater()

    init(container: Container, card: Card) {
        game = container.resolve(GameManagerProtocol.self)!
        self.card = card

        let _borderColor = DerivedProperty(isSelected) { isSelected in
            isSelected ? Color(UIColor.systemBlue) : Color.gray
        }
        updater.bind(object: self, keyPath: \.borderColor, toProperty: _borderColor)

        let _borderWidth = DerivedProperty<CGFloat>(isSelected) { isSelected in
            isSelected ? 3 : 1
        }
        updater.bind(object: self, keyPath: \.borderWidth, toProperty: _borderWidth)
    }

    func toggleSelected() {
        isSelected.value = !isSelected.value

        if isSelected.value {
            game.selectCard(card)
        } else {
            game.deselectCard(card)
        }
    }
}
