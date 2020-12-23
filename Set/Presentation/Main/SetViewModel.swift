//
//  SetViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import Yoyo

class SetViewModel {
    private let game: GameManagerProtocol!

    let addCardsEnabled: Property<Bool>

    let deal: Property<[Card]>

    private let deck: Property<[Card]>

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        deck = game.deck
        deal = game.deal

        addCardsEnabled = DerivedProperty(game.deck) { deck in
            return deck.count > 0
        }
    }

    func newGame() {
        game.newGame()
    }

    func addCards() {
        game.addCards()
    }

    func selectCard(atIndex index: Int) {
        game.selectCard(atIndex: index)
    }

    func deselectCard(atIndex index: Int) {
        game.deselectCard(atIndex: index)
    }
}
