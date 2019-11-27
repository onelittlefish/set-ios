//
//  TestSetViewModel.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import RxTest
import RxSwift
import RxCocoa

class TestSetViewModel: XCTestCase {
    private let scheduler = TestScheduler(initialClock: 0)
    private let disposeBag = DisposeBag()

    private var container: Container!

    private var game: MockGameManager!

    private var model: SetViewModel!

    override func setUp() {
        game = MockGameManager(scheduler: scheduler)
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
    }

    private func initModel() {
        model = SetViewModel(container: container)
    }

    func testCardSelected() {
        var cardSelectedElements: [Int] = []
        game.cardSelected.subscribe({ event in
            cardSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        initModel()
        Observable.of(
            IndexPath(row: 1, section: 2),
            IndexPath(row: 3, section: 4)
        ).bind(to: model.cardSelected).disposed(by: disposeBag)

        XCTAssertEqual(cardSelectedElements, [1, 3])
    }

    func testCardDeselected() {
        var cardDeselectedElements: [Int] = []
        game.cardDeselected.subscribe({ event in
            cardDeselectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        initModel()
        Observable.of(
            IndexPath(row: 1, section: 2),
            IndexPath(row: 3, section: 4)
        ).bind(to: model.cardDeselected).disposed(by: disposeBag)

        XCTAssertEqual(cardDeselectedElements, [1, 3])
    }

    func testAddCardsEnabled() {
        game.deck = scheduler.createHotObservable([
            .next(0, Card.allCards()),
            .next(10, [])
        ]).asObservable()

        initModel()
        let addCardsEnabled = scheduler.createObserver(Bool.self)
        model.addCardsEnabled.asDriver(onErrorJustReturn: false).drive(addCardsEnabled).disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(addCardsEnabled.events, [
            .next(0, true),
            .next(10, false)
        ])
    }
/*
    func testNewGame() {
        game.deal = Card.allCards()
        model.selectCard(atIndex: 0)
        XCTAssertFalse(model.selectedCards.isEmpty)

        model.newGame()
        MOAssertTimesCalled(game.methodReference(.newGame), 1)
        XCTAssertTrue(model.selectedCards.isEmpty)

        XCTAssertEqual(timesReloadCardsNotified, 1)
        XCTAssertEqual(timesReloadSummaryNotified, 1)
    }

    func testAddCards() {
        model.addCards()
        MOAssertTimesCalled(game.methodReference(.dealMoreCards), 1)

        XCTAssertEqual(timesReloadSummaryNotified, 1)
    }

    func testSelectCardFormingSet() {
        game.methodReference(.handlePossibleSet).setCustomBehaviorToReturn(true)

        game.deal = [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .two, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .three, shape: .squiggle, fill: .solid)
        ]

        model.selectCard(atIndex: 0)
        XCTAssertEqual(model.selectedCards.count, 1)

        model.selectCard(atIndex: 1)
        XCTAssertEqual(model.selectedCards.count, 2)

        model.selectCard(atIndex: 2)
        XCTAssertEqual(model.selectedCards.count, 0)

        XCTAssertEqual(timesReloadCardsNotified, 1)
        XCTAssertEqual(timesReloadSummaryNotified, 1)
    }

    func testSelectCardNotFormingSet() {
        game.methodReference(.handlePossibleSet).setCustomBehaviorToReturn(false)

        game.deal = [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .two, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .three, shape: .squiggle, fill: .solid)
        ]

        model.selectCard(atIndex: 0)
        XCTAssertEqual(model.selectedCards.count, 1)

        model.selectCard(atIndex: 1)
        XCTAssertEqual(model.selectedCards.count, 2)

        model.selectCard(atIndex: 2)
        XCTAssertEqual(model.selectedCards.count, 3)

        XCTAssertEqual(timesReloadCardsNotified, 0)
        XCTAssertEqual(timesReloadSummaryNotified, 0)
    }

    func testSelectExistingCard() {
        game.methodReference(.handlePossibleSet).setCustomBehaviorToReturn(true)

        game.deal = [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid)
        ]

        model.selectCard(atIndex: 0)
        model.selectCard(atIndex: 0)
        XCTAssertEqual(model.selectedCards.count, 1)
    }

    func testDeselectCard() {
        game.deal = [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid)
        ]

        model.selectCard(atIndex: 0)
        model.deselectCard(atIndex: 0)
        XCTAssertEqual(model.selectedCards.count, 0)
    }

    func testDeselectInvalidCard() {
        game.deal = [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .two, shape: .squiggle, fill: .solid)
        ]

        model.selectCard(atIndex: 0)
        model.deselectCard(atIndex: 1)
        XCTAssertEqual(model.selectedCards.count, 1)
    }
*/
}
