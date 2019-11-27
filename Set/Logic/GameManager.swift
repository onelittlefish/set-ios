//
//  GameManager.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol GameManagerProtocol {
    var newGame: PublishRelay<Void> { get }
    var addCards: PublishRelay<Void> { get }
    var cardSelected: PublishRelay<Int> { get }
    var cardDeselected: PublishRelay<Int> { get }

    var deck: Observable<[Card]> { get }
    var deal: Observable<[Card]> { get }

    var numberOfSetsFound: Observable<Int> { get }
    var numberOfSetsInDeal: Observable<Int> { get }
}

enum SelectionAction {
    case selectCard(Int), deselectCard(Int), clearSelection
}

class GameManager: GameManagerProtocol {
    private let deckManager: DeckManagerProtocol

    let newGame = PublishRelay<Void>()
    let addCards = PublishRelay<Void>()
    let cardSelected = PublishRelay<Int>()
    let cardDeselected = PublishRelay<Int>()

    private let setSelected = PublishRelay<[Card]>()

    let deck: Observable<[Card]>
    let deal: Observable<[Card]>

    let numberOfSetsFound: Observable<Int>
    let numberOfSetsInDeal: Observable<Int>

    private let disposeBag = DisposeBag()

    init(deckManager: DeckManagerProtocol) {
        self.deckManager = deckManager

        // Deck state
        let newGameAction = newGame.share()
        newGameAction.bind(to: deckManager.newGame).disposed(by: disposeBag)
        addCards.bind(to: deckManager.addCards).disposed(by: disposeBag)
        setSelected.bind(to: deckManager.clearCards).disposed(by: disposeBag)
        deck = deckManager.deck
        deal = deckManager.deal

        // Selected card state
        let clearSelectionAction = Observable.merge(
            newGameAction.map({ _ in SelectionAction.clearSelection }),
            setSelected.map({ _ in SelectionAction.clearSelection })
        )
        let actionsAffectingSelection = Observable.merge(
            clearSelectionAction,
            cardSelected.map({ SelectionAction.selectCard($0) }),
            cardDeselected.map({ SelectionAction.deselectCard($0) })
        )
        let selectedIndices: Observable<[Int]> = actionsAffectingSelection.scan([], accumulator: { indices, action in
            switch action {
            case .clearSelection:
                return []
            case .selectCard(let index):
                if !indices.contains(index) {
                    return indices + [index]
                } else {
                    return indices
                }
            case .deselectCard(let index):
                return indices.filter({ $0 != index })
            }
        }).share()
        let selectedCards: Observable<[Card]> = Observable.combineLatest(deal, selectedIndices).map({ deal, selectedIndices in
            return selectedIndices.compactMap({ index in
                if index < deal.count {
                    return deal[index]
                } else {
                    return nil
                }
            })
        }).distinctUntilChanged()
        // React when the selection comprises a set
        selectedCards.filter({ selectedCards in
            return selectedCards.count == 3 && Card.thirdCardForSetWith(selectedCards[0], selectedCards[1]) == selectedCards[2]
        }).distinctUntilChanged().observeOn(MainScheduler.asyncInstance).bind(to: setSelected).disposed(by: disposeBag)

        // Derived state
        numberOfSetsFound = Observable.merge(
            newGameAction.map({ _ in DeckAction.newGame }),
            setSelected.map({ DeckAction.clearCards($0) })
        ).scan(0, accumulator: { setsFound, action in
            switch action {
            case .newGame:
                return 0
            case .addCards:
                return setsFound
            case .clearCards:
                return setsFound + 1
            }
        })

        numberOfSetsInDeal = deal.map({ deal -> Int in
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
        })
    }
}
