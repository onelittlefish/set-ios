//
//  SummaryViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import Yoyo

struct SummaryStat: Equatable {
    let label: String
    let value: String
}

class SummaryViewModel {
    private let game: GameManagerProtocol!

    let stats: Property<[SummaryStat]>

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        let cardsLeft = DerivedProperty(game.deck) { deck in
            return deck.count
        }

        stats = DerivedProperty(game.numberOfSetsFound, cardsLeft, game.numberOfSetsInDeal) { numberOfSetsFound, cardsLeft, numberOfSetsInDeal in
            return [
                SummaryStat(label: NSLocalizedString("Found", comment: "Label for number of sets found"), value: "\(numberOfSetsFound)"),
                SummaryStat(label: NSLocalizedString("Left", comment: "Label for number of cards left"), value: "\(cardsLeft)"),
                SummaryStat(label: NSLocalizedString("Sets", comment: "Label for number of sets in deal"), value: "\(numberOfSetsInDeal)")
            ]
        }
    }
}
