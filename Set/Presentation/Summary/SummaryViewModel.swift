//
//  SummaryViewModel.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import Swinject
import RxSwift

class SummaryViewModel {
    typealias SummaryStat = (label: String, value: String)

    private let game: GameManagerProtocol!

    let stats: Observable<[SummaryStat]>

    private let disposeBag = DisposeBag()

    init(container: Container) {
        game = container.resolve(GameManagerProtocol.self)!

        let cardsLeft = game.deck.map({ deck in
            return deck.count
        })

        stats = Observable.combineLatest(game.numberOfSetsFound, cardsLeft, game.numberOfSetsInDeal).map({ numberOfSetsFound, cardsLeft, numberOfSetsInDeal in
            return [
                (NSLocalizedString("Found", comment: "Label for number of sets found"), "\(numberOfSetsFound)"),
                (NSLocalizedString("Left", comment: "Label for number of cards left"), "\(cardsLeft)"),
                (NSLocalizedString("Sets", comment: "Label for number of sets in deal"), "\(numberOfSetsInDeal)")
            ]
        })
    }
}
