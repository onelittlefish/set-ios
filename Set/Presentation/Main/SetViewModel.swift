//
//  SetViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject

class SetViewModel {
    private let game: GameManagerProtocol!

    private(set) var selectedCards: [Card] = []

    let reloadCards = Notification.Name("reloadCards")
    let reloadSummary = Notification.Name("reloadSummary")

    var deck: [Card] {
        return game.deck
    }

    var deal: [Card] {
        return game.deal
    }

    var addCardsEnabled: Bool {
        return deck.count > 0
    }

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!
    }

    func newGame() {
        game.newGame()
        selectedCards = []

        notify(reloadCards)
        notify(reloadSummary)
    }

    func addCards() {
        game.dealMoreCards()

        notify(reloadSummary)
    }

    func selectCard(atIndex index: Int) {
        let selectedCard = deal[index]

        if !selectedCards.contains(selectedCard) {
            selectedCards.append(selectedCard)
        }

        if selectedCards.count == 3 {
            if game.handlePossibleSet(selectedCards) {
                selectedCards = []

                notify(reloadCards)
                notify(reloadSummary)
            }
        }
    }

    func deselectCard(atIndex index: Int) {
        if let index = selectedCards.firstIndex(of: deal[index]) {
            selectedCards.remove(at: index)
        }
    }

    private func notify(_ notification: Notification.Name) {
        NotificationCenter.default.post(name: notification, object: self)
    }

}
