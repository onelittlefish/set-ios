//
//  DeckManager.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol DeckManagerProtocol {
    var newGame: PublishRelay<Void> { get }
    var addCards: PublishRelay<Void> { get }
    var clearCards: PublishRelay<[Card]> { get }

    var deck: Observable<[Card]> { get }
    var deal: Observable<[Card]> { get }
}

struct DeckState {
    let deck: [Card]
    let deal: [Card]
}

enum DeckAction {
    case newGame, addCards, clearCards([Card])
}

class DeckManager: DeckManagerProtocol {
    let newGame = PublishRelay<Void>()
    let addCards = PublishRelay<Void>()
    let clearCards = PublishRelay<[Card]>()

    let deck: Observable<[Card]>
    let deal: Observable<[Card]>

    private let disposeBag = DisposeBag()

    init() {
        let actionsAffectingDeck = Observable.merge(
            newGame.map({ _ in DeckAction.newGame }),
            addCards.map({ _ in DeckAction.addCards }),
            clearCards.map({ DeckAction.clearCards($0) })
        )

        let deckState: Observable<DeckState> = actionsAffectingDeck.scan(DeckState(deck: [], deal: []), accumulator: { deckState, action in
            switch action {
            case .newGame:
                // Reset deck, deal out 12 cards
                let newCards = Card.allCards().shuffled()
                let newDeck = Array(newCards.dropLast(12))
                let newDeal = Array(newCards.dropFirst(newCards.count - 12))
                return DeckState(deck: newDeck, deal: newDeal)
            case .addCards:
                if deckState.deck.count >= 3 {
                    // Deal out 3 cards
                    let newDeck = Array(deckState.deck.dropLast(3))
                    let newDeal = Array(deckState.deal + deckState.deck.dropFirst(deckState.deck.count - 3))
                    return DeckState(deck: newDeck, deal: newDeal)
                } else {
                    // No more cards in deck
                    return deckState
                }
            case .clearCards(let cards):
                var currentDeck = deckState.deck
                var currentDeal = deckState.deal

                // Remove cards
                for card in cards {
                    guard let index = currentDeal.firstIndex(of: card) else {
                        assertionFailure("Tried to clear a card that is not present in the deal")
                        continue
                    }

                    currentDeal.remove(at: index)

                    if currentDeal.count < 12 {
                        // Replace cleared card
                        if let newDeal = currentDeck.last {
                            currentDeal.insert(newDeal, at: index)
                            currentDeck = currentDeck.dropLast()
                        }
                    }
                }

                return DeckState(deck: currentDeck, deal: currentDeal)
            }
        }).share()

        deck = deckState.map({ $0.deck }).share()
        deal = deckState.map({ $0.deal }).share()
    }

}
