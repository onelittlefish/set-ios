//
//  SUISetViewModel.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI
import Swinject
import Yoyo

@available(iOS 13.0, *)
class SUISetViewModel: ObservableObject {
    private let game: GameManagerProtocol

    @Published private(set) var addCardsDisabled = false
    @Published private(set) var addCardsForegroundColor = Color.white

    private let updater = YoyoUpdater()

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        let _addCardsDisabled = DerivedProperty(game.deck) { deck in
            deck.isEmpty
        }
        let _addCardsForegroundColor = DerivedProperty<Color>(_addCardsDisabled) { addCardsDisabled in
            addCardsDisabled ? .white.opacity(0.5) : .white
        }
        updater.bind(object: self, keyPath: \.addCardsDisabled, toProperty: _addCardsDisabled)
        updater.bind(object: self, keyPath: \.addCardsForegroundColor, toProperty: _addCardsForegroundColor)

        newGame()
    }

    func newGame() {
        game.newGame()
    }

    func addCards() {
        game.addCards()
    }
}
