//
//  TestGame.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import RxTest
import RxSwift
import RxCocoa

class TestGameManager: XCTestCase { // swiftlint:disable:this type_body_length
    private let scheduler = TestScheduler(initialClock: 0)
    private let disposeBag = DisposeBag()

    private var container: Container!

    private var deckManager: MockDeckManager!

    private var manager: GameManager!

    override func setUp() {
        deckManager = MockDeckManager(scheduler: scheduler)
    }

    private func initManager() {
        manager = GameManager(deckManager: deckManager)
    }

    func testDuplicateAndInvalidCardsSelected() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent())
        ]).asObservable()

        initManager()

        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 1),
            .next(40, 10),
            .next(50, 2)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements, [validSetAllDifferent()])
    }

    func testDuplicateAndInvalidCardsDeselected() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent())
        ]).asObservable()

        initManager()

        let selected = scheduler.createHotObservable([
            .next(10, 0)
        ])
        let deselected = scheduler.createHotObservable([
            .next(20, 0),
            .next(30, 0),
            .next(40, 10)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)
        deselected.bind(to: manager.cardDeselected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements, [])
    }

    func testSetSelected() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent())
        ]).asObservable()

        initManager()

        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements, [validSetAllDifferent()])
    }

    func testNotASetSelected() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, invalidSet())
        ]).asObservable()

        initManager()

        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements, [])
    }

    func testCardDeselected1() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent() + validSetAllDifferent())
        ]).asObservable()

        initManager()

        /*
         Deal out 6 cards (valid set * 2)
         Select 0, 1
         Deselect 0
         Select 2, 3

         Expectation: 1, 2, 3 is a valid set
         */
        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2),
            .next(40, 3)
        ])
        let deselected = scheduler.createHotObservable([
            .next(25, 0)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)
        deselected.bind(to: manager.cardDeselected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        let expectedSet = [validSetAllDifferent()[1], validSetAllDifferent()[2], validSetAllDifferent()[0]]
        XCTAssertEqual(setSelectedElements, [expectedSet])
    }

    func testCardDeselected2() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent() + invalidSet())
        ]).asObservable()

        initManager()

        /*
         Deal out 6 cards (valid set + invalid set)
         Select 0, 1
         Deselect 0
         Select 2, 3, 0
         Deselect 3

         Expectation: 0, 1, 2 is a valid set
         */
        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2),
            .next(40, 3),
            .next(40, 0)
        ])
        let deselected = scheduler.createHotObservable([
            .next(25, 0),
            .next(45, 3)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)
        deselected.bind(to: manager.cardDeselected).disposed(by: disposeBag)

        scheduler.start()

        wait(milliseconds: 100) // wait for async scheduler
        let expectedSet = [validSetAllDifferent()[1], validSetAllDifferent()[2], validSetAllDifferent()[0]]
        XCTAssertEqual(setSelectedElements, [expectedSet])
    }

    func testSelectedCardsClearedAfterSetSelected() {
        var setSelectedElements: [[Card]] = []
        deckManager.clearCards.subscribe({ event in
            setSelectedElements.append(event.element!)
        }).disposed(by: disposeBag)

        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent()),
            .next(31, validSetShapeDifferent())
        ]).asObservable()

        initManager()

        /*
         Deal out 3 cards (valid set)
         Select set 0, 1, 2
         Wait for async setSelected event
         Deal out 3 different cards (valid set)
         Deselect 2
         Select 2

         Expectation: Deselecting and reselecting 2 should not count as a
         valid set since the 0, 1, 2 selection should have been cleared out.
         */
        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2),
            .next(40, 2)
        ])
        let deselected = scheduler.createHotObservable([
            .next(35, 2)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)
        deselected.bind(to: manager.cardDeselected).disposed(by: disposeBag)

        scheduler.advanceTo(30)
        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements.count, 1)

        scheduler.advanceTo(50)
        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(setSelectedElements.count, 1)
    }

    func testNumberOfSetsFound() {
        deckManager.deal = scheduler.createHotObservable([
            .next(0, validSetAllDifferent())
        ]).asObservable()

        initManager()
        let numberOfSetsFound = scheduler.createObserver(Int.self)
        manager.numberOfSetsFound.asDriver(onErrorJustReturn: 0).drive(numberOfSetsFound).disposed(by: disposeBag)

        /*
         Deal out 3 cards (valid set)
         Select set 0, 1, 2
         Wait for async setSelected event
         Add cards
         Start a new game
         */
        let selected = scheduler.createHotObservable([
            .next(10, 0),
            .next(20, 1),
            .next(30, 2)
        ])
        selected.bind(to: manager.cardSelected).disposed(by: disposeBag)
        scheduler.createHotObservable([
            .next(40, ())
        ]).bind(to: manager.addCards).disposed(by: disposeBag)
        scheduler.createHotObservable([
            .next(50, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)

        scheduler.advanceTo(30)
        wait(milliseconds: 100) // wait for async scheduler
        XCTAssertEqual(numberOfSetsFound.events, [
            .next(30, 1)
        ])

        scheduler.advanceTo(50)
        XCTAssertEqual(numberOfSetsFound.events, [
            .next(30, 1),
            .next(50, 0)
        ])
    }

    func testNumberOfSets() {
        deckManager.deal = scheduler.createHotObservable([
            .next(0, invalidSet()),
            .next(10, validSetAllDifferent()),
            .next(20, threeSets())
        ]).asObservable()

        initManager()
        let numberOfSetsInDeal = scheduler.createObserver(Int.self)
        manager.numberOfSetsInDeal.asDriver(onErrorJustReturn: 0).drive(numberOfSetsInDeal).disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(numberOfSetsInDeal.events, [
            .next(0, 0),
            .next(10, 1),
            .next(20, 3)
        ])
    }

    // MARK: - Helpers

    private func validSetAllDifferent() -> [Card] {
        return [
            Card(color: .red, number: .one, shape: .squiggle, fill: .lined),
            Card(color: .green, number: .two, shape: .pill, fill: .empty),
            Card(color: .purple, number: .three, shape: .diamond, fill: .solid)
        ]
    }

    private func validSetShapeDifferent() -> [Card] {
        let color = Card.Color.purple
        let number = Card.Number.one
        let fill = Card.Fill.lined

        return [
            Card(color: color, number: number, shape: .squiggle, fill: fill),
            Card(color: color, number: number, shape: .pill, fill: fill),
            Card(color: color, number: number, shape: .diamond, fill: fill)
        ]
    }

    private func invalidSet() -> [Card] {
        return [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .one, shape: .pill, fill: .solid),
            Card(color: .green, number: .three, shape: .diamond, fill: .solid)
        ]
    }

    private func threeSets() -> [Card] {
        return [
            /* Set 1 */
            Card(color: .red, number: .one, shape: .diamond, fill: .empty),
            Card(color: .red, number: .one, shape: .pill, fill: .empty),
            Card(color: .red, number: .one, shape: .squiggle, fill: .empty),
            /* Set 2 (with the first item */
            Card(color: .red, number: .one, shape: .diamond, fill: .lined),
            Card(color: .red, number: .one, shape: .diamond, fill: .solid),
            /* Set 3 */
            Card(color: .red, number: .two, shape: .pill, fill: .solid),
            Card(color: .green, number: .two, shape: .pill, fill: .solid),
            Card(color: .purple, number: .two, shape: .pill, fill: .solid),
            /* Not in a set */
            Card(color: .red, number: .two, shape: .squiggle, fill: .lined)
        ]
    }
}
