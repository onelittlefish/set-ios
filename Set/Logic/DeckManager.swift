//
//  DeckManager.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Yoyo

protocol DeckManagerProtocol {
    var deck: Property<[Card]> { get }
    var deal: Property<[Card]> { get }

    func newGame()
    func addCards()
    func clearCards(_ cards: [Card])
}

class DeckManager: DeckManagerProtocol {
    let deck: Property<[Card]>
    private let _deck = StoredProperty<[Card]>([])

    let deal: Property<[Card]>
    private let _deal = StoredProperty<[Card]>([])

    init() {
        deck = _deck
        deal = _deal
    }

    func newGame() {
        // Reset deck, deal out 12 cards
        let newCards = Card.allCards().shuffled()
        let deal12 = deal(numberOfCards: 12, fromDeck: newCards)
        _deck.value = deal12.deck
        _deal.value = deal12.deal
    }

    func addCards() {
        let deal3 = deal(numberOfCards: 3, fromDeck: deck.value)
        _deck.value = deal3.deck
        _deal.value = deal.value + deal3.deal
    }

    func clearCards(_ cards: [Card]) {
        var currentDeck = deck.value
        var currentDeal = deal.value

        // Remove cards
        let validCards = cards.filter({ currentDeal.contains($0) })
        validCards.forEach({ card in
            guard let index = currentDeal.firstIndex(of: card) else { return }
            currentDeal.remove(at: index)

            if currentDeal.count < 12 {
                // Replace cleared card
                let deal1 = deal(numberOfCards: 1, fromDeck: currentDeck)
                if let newDeal = deal1.deal.first {
                    currentDeck = deal1.deck
                    currentDeal.insert(newDeal, at: index)
                }
            }
        })

        _deck.value = currentDeck
        _deal.value = currentDeal
    }

    /**
     Removes cards from the deck and returns the modified deck and the cards that were removed (dealt).
     If `numberOfCards` is greater than the number of cards in the deck, the entire remaining deck
     will be dealt.
     - returns: A tuple containing the deck after up to `numberOfCards` cards have been removed (`deck`)
     and the cards that were removed (`deal`)
     */
    private func deal(numberOfCards: Int, fromDeck deck: [Card]) -> (deck: [Card], deal: [Card]) {
        let numberOfCards = min(numberOfCards, deck.count)
        let newDeck = Array(deck.dropLast(numberOfCards))
        let deal = Array(deck.dropFirst(deck.count - numberOfCards))
        return (newDeck, deal)
    }

}
