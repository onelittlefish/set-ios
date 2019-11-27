//
//  MockDeckManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
@testable import Set
import RxSwift
import RxRelay
import RxTest

class MockDeckManager: DeckManagerProtocol {
    let newGame = PublishRelay<Void>()
    let addCards = PublishRelay<Void>()
    let clearCards = PublishRelay<[Card]>()

    var deck: Observable<[Card]>
    var deal: Observable<[Card]>

    var scheduler: TestScheduler

    init(scheduler: TestScheduler) {
        self.scheduler = scheduler

        deck = scheduler.createHotObservable([
            .next(0, [])
        ]).asObservable()

        deal = scheduler.createHotObservable([
            .next(0, [])
        ]).asObservable()
    }
}
