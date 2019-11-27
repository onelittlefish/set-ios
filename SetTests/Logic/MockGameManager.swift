//
//  MockGameManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
@testable import Set
import RxSwift
import RxRelay
import RxTest

class MockGameManager: GameManagerProtocol {
    let newGame = PublishRelay<Void>()
    let addCards = PublishRelay<Void>()
    let cardSelected = PublishRelay<Int>()
    let cardDeselected = PublishRelay<Int>()

    var deck: Observable<[Card]>
    var deal: Observable<[Card]>

    var numberOfSetsFound: Observable<Int>
    var numberOfSetsInDeal: Observable<Int>

    var scheduler: TestScheduler

    init(scheduler: TestScheduler) {
        self.scheduler = scheduler

        deck = scheduler.createHotObservable([
            .next(0, [])
        ]).asObservable()

        deal = scheduler.createHotObservable([
            .next(0, [])
        ]).asObservable()

        numberOfSetsFound = scheduler.createHotObservable([
            .next(0, 0)
        ]).asObservable()

        numberOfSetsInDeal = scheduler.createHotObservable([
            .next(0, 3)
        ]).asObservable()
    }
}
