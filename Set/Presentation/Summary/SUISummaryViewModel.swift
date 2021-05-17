//
//  SUISummaryViewModel.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI
import Swinject
import Yoyo

struct SUISummaryStat: Equatable, Identifiable {
    let label: String
    let value: String
    let id = UUID()
}

@available(iOS 13.0, *)
class SUISummaryViewModel: ObservableObject {
    private let game: GameManagerProtocol!

    @Published private(set) var stats: [SUISummaryStat] = []

    private let updater = YoyoUpdater()

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        let cardsLeft = DerivedProperty(game.deck) { deck in
            return deck.count
        }

        let _stats = DerivedProperty(game.numberOfSetsFound, cardsLeft, game.numberOfSetsInDeal) { numberOfSetsFound, cardsLeft, numberOfSetsInDeal in
            return [
                SUISummaryStat(label: NSLocalizedString("Found", comment: "Label for number of sets found"), value: "\(numberOfSetsFound)"),
                SUISummaryStat(label: NSLocalizedString("Left", comment: "Label for number of cards left"), value: "\(cardsLeft)"),
                SUISummaryStat(label: NSLocalizedString("Sets", comment: "Label for number of sets in deal"), value: "\(numberOfSetsInDeal)")
            ]
        }
        updater.bind(object: self, keyPath: \.stats, toProperty: _stats)
    }
}
