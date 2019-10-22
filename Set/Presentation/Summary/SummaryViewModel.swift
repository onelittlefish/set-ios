//
//  SummaryViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject

class SummaryViewModel {
    private let game: GameManagerProtocol!

    var numberOfSetsFound: Int {
        return game.numberOfSetsFound
    }

    var numberOfSetsInDeal: Int {
        return game.numberOfSetsInDeal
    }

    var cardsLeft: Int {
        return game.deck.count
    }

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!
    }
}
