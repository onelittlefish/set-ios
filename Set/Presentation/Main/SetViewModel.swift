//
//  SetViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxRelay

class SetViewModel {
    private let game: GameManagerProtocol!

    let newGame = PublishRelay<Void>()
    let addCards = PublishRelay<Void>()
    let cardSelected = PublishRelay<IndexPath>()
    let cardDeselected = PublishRelay<IndexPath>()

    let deck: Observable<[Card]>
    let deal: Observable<[Card]>

    let addCardsEnabled: Observable<Bool>

    private let disposeBag = DisposeBag()

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        newGame.bind(to: game.newGame).disposed(by: disposeBag)
        addCards.bind(to: game.addCards).disposed(by: disposeBag)
        cardSelected.map({ $0.row }).bind(to: game.cardSelected).disposed(by: disposeBag)
        cardDeselected.map({ $0.row }).bind(to: game.cardDeselected).disposed(by: disposeBag)

        deck = game.deck
        deal = game.deal

        addCardsEnabled = deck.map({ deck in
            return deck.count > 0
        })
    }
}
