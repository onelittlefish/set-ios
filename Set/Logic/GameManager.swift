//
//  GameManager.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Yoyo

protocol GameManagerProtocol {
    var deck: Property<[Card]> { get }
    var deal: Property<[Card]> { get }

    var numberOfSetsFound: Property<Int> { get }
    var numberOfSetsInDeal: Property<Int> { get }

    func newGame()
    func addCards()
    func selectCard(atIndex index: Int)
    func selectCard(_ card: Card)
    func deselectCard(atIndex index: Int)
    func deselectCard(_ card: Card)
}

class GameManager: GameManagerProtocol {
    private let deckManager: DeckManagerProtocol

    let deck: Property<[Card]>
    let deal: Property<[Card]>

    let numberOfSetsFound: Property<Int>
    private let _numberOfSetsFound = StoredProperty(0)

    let numberOfSetsInDeal: Property<Int>

    private let selectedCards = StoredProperty<[Card]>([])
    private let setSelected: Property<Bool>

    private let updater = YoyoUpdater()

    init(deckManager: DeckManagerProtocol) {
        self.deckManager = deckManager

        numberOfSetsFound = _numberOfSetsFound

        deck = deckManager.deck
        deal = deckManager.deal

        numberOfSetsInDeal = DerivedProperty(deckManager.deal) { deal in
            var numSets = 0
            for card1 in deal {
                for card2 in deal where card1 != card2 {
                    let card3 = Card.thirdCardForSetWith(card1, card2)
                    if deal.contains(card3) {
                        numSets += 1
                    }
                }
            }
            return numSets / 6
        }

        setSelected = DerivedProperty(selectedCards) { selectedCards in
            return selectedCards.count == 3 && Card.thirdCardForSetWith(selectedCards[0], selectedCards[1]) == selectedCards[2]
        }

        updater.onTransition(setSelected) { [unowned self] _, setSelected in
            if setSelected {
                self.clearSelectedSet()
            }
        }
    }

    func newGame() {
        deckManager.newGame()
        _numberOfSetsFound.value = 0
        selectedCards.value = []
    }

    func addCards() {
        deckManager.addCards()
    }

    func selectCard(atIndex index: Int) {
        guard deal.value.count > index else { print("Attempted to select card at invalid index \(index)"); return }
        let card = deal.value[index]
        selectCard(card)
    }

    func selectCard(_ card: Card) {
        if !selectedCards.value.contains(card) {
            selectedCards.value.append(card)
        }
    }

    func deselectCard(atIndex index: Int) {
        guard deal.value.count > index else { print("Attempted to deselect card at invalid index \(index)"); return }
        let card = deal.value[index]
        deselectCard(card)
    }

    func deselectCard(_ card: Card) {
        selectedCards.value.removeAll(where: { $0 == card })
    }

    private func clearSelectedSet() {
        _numberOfSetsFound.value += 1
        deckManager.clearCards(selectedCards.value)
        selectedCards.value = []
    }

}
