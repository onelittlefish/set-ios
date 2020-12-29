//
//  SetViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import Yoyo

extension NSNotification.Name {
    static let SetViewModelReloadAllCards = NSNotification.Name("SetViewModelReloadAllCards")
    /// UserInfo will have key `indexPaths` with value `[IndexPath]` of added cards
    static let SetViewModelCardsAdded = NSNotification.Name("SetViewModelCardsAdded")
    /// UserInfo will have key `indexPaths` with value `[IndexPath]` of removed cards
    static let SetViewModelCardsRemoved = NSNotification.Name("SetViewModelCardsRemoved")
    /// UserInfo will have key `indexPaths` with value `[IndexPath]` of replaced cards
    static let SetViewModelCardsReplaced = NSNotification.Name("SetViewModelCardsReplaced")
}

class SetViewModel {
    private let game: GameManagerProtocol!

    let addCardsEnabled: Property<Bool>
    let deal: Property<[Card]>

    private let deck: Property<[Card]>

    private let updater = YoyoUpdater()
    private var startingNewGame = false

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        deck = game.deck
        deal = game.deal

        addCardsEnabled = DerivedProperty(game.deck) { deck in
            return deck.count > 0
        }

        updater.onTransition(game.deal) { [unowned self] old, new in
            self.fireUpdateEvents(oldDeal: old, newDeal: new)
        }
    }

    private func fireUpdateEvents(oldDeal: [Card]?, newDeal: [Card]) {
        guard let oldDeal = oldDeal, !startingNewGame else {
            NotificationCenter.default.post(name: .SetViewModelReloadAllCards, object: self)
            return
        }

        if oldDeal.count == newDeal.count {
            let cardChangedIndices = newDeal.enumerated().filter({ index, card in
                oldDeal[index] != card
            }).map({ IndexPath(item: $0.offset, section: 0) })
            NotificationCenter.default.post(name: .SetViewModelCardsReplaced, object: self, userInfo: ["indexPaths": cardChangedIndices])
            return
        }

        // In iOS 13+, Collections have a difference(from:) method that may remove the need for CardWithIndex
        let oldSet = Set(oldDeal.enumerated().map({ index, card in CardWithIndex(card: card, index: index) }))
        let newSet = Set(newDeal.enumerated().map({ index, card in CardWithIndex(card: card, index: index) }))
        let oldOnly = oldSet.subtracting(newSet)
        let newOnly = newSet.subtracting(oldSet)

        let deletedIndexPaths = oldOnly.map({ IndexPath(item: $0.index, section: 0) })
        if !deletedIndexPaths.isEmpty {
            NotificationCenter.default.post(name: .SetViewModelCardsRemoved, object: self, userInfo: ["indexPaths": deletedIndexPaths])
        }

        let addedIndexPaths = newOnly.map({ IndexPath(item: $0.index, section: 0) })
        if !addedIndexPaths.isEmpty {
            NotificationCenter.default.post(name: .SetViewModelCardsAdded, object: self, userInfo: ["indexPaths": addedIndexPaths])
        }
    }

    func newGame() {
        startingNewGame = true
        game.newGame()
        startingNewGame = false
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

private struct CardWithIndex: Hashable {
    let card: Card
    let index: Int

    static func == (lhs: CardWithIndex, rhs: CardWithIndex) -> Bool {
        return lhs.card == rhs.card
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(card)
    }
}
