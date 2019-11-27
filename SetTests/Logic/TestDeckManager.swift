//
//  TestDeckManager.swift
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

class TestDeckManager: XCTestCase {
    private let scheduler = TestScheduler(initialClock: 0)
    private let disposeBag = DisposeBag()

    private var manager: DeckManager!

    override func setUp() {
        manager = DeckManager()
    }

    func testNewGame() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(10, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        scheduler.start()

        XCTAssertEqual(deck.events.last?.value.element?.count, 81 - 12)
        XCTAssertEqual(deal.events.last?.value.element?.count, 12)
    }

    func testAddCards() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(10, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        scheduler.createHotObservable([
            .next(20, ())
        ]).bind(to: manager.addCards).disposed(by: disposeBag)
        scheduler.start()

        XCTAssertEqual(deck.events.last?.value.element?.count, 81 - 12 - 3)
        XCTAssertEqual(deal.events.last?.value.element?.count, 15)
    }

    func testAddCardsEmptyDeck() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(0, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        // After adding cards 69 / 3 = 23 times, the deck should be empty; additional attempt to add cards should do nothing
        let addCardsRepeatedly = (1...30).map({ time in
            return Recorded.next(time, ())
        })
        scheduler.createHotObservable(addCardsRepeatedly).bind(to: manager.addCards).disposed(by: disposeBag)
        scheduler.start()

        XCTAssertEqual(deck.events.last?.value.element?.count, 0)
        XCTAssertEqual(deal.events.last?.value.element?.count, 81)
    }

    func testClearCards() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(0, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        scheduler.advanceTo(0)

        // Clear the first 3 cards
        let firstDeal = deal.events.last!.value.element!
        let set = Array(firstDeal[0...2])
        scheduler.createHotObservable([
            .next(10, set)
        ]).bind(to: manager.clearCards).disposed(by: disposeBag)
        scheduler.advanceTo(10)

        XCTAssertEqual(deck.events.last?.value.element?.count, 81 - 12 - 3)
        XCTAssertEqual(deal.events.last?.value.element?.count, 12)

        let secondDeal = deal.events.last!.value.element!
        set.forEach({ XCTAssertFalse(secondDeal.contains($0), "Selected cards should be removed from deal") })
        secondDeal[0...2].forEach({ XCTAssertFalse(firstDeal.contains($0), "New cards should be added") })
        XCTAssertEqual(firstDeal.dropFirst(3), secondDeal.dropFirst(3), "New cards should be added in the positions of the selected cards")
    }

    func testClearCardsMoreThan12CardsInDeal() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(0, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        // Add cards so there are now 15 cards in the deal
        scheduler.createHotObservable([
            .next(20, ())
        ]).bind(to: manager.addCards).disposed(by: disposeBag)
        scheduler.advanceTo(20)

        XCTAssertEqual(deal.events.last?.value.element?.count, 15)

        // Clear the first 3 cards
        let currentDeal = deal.events.last!.value.element!
        let set = Array(currentDeal[0...2])
        scheduler.createHotObservable([
            .next(30, set)
        ]).bind(to: manager.clearCards).disposed(by: disposeBag)
        scheduler.advanceTo(30)

        XCTAssertEqual(deck.events.last?.value.element?.count, 81 - 12 - 3, "More cards should not be dealt if deal already had more than 12")
        XCTAssertEqual(deal.events.last?.value.element?.count, 12)
    }

    func testClearCardsEmptyDeck() {
        let deck = scheduler.createObserver([Card].self)
        manager.deck.asDriver(onErrorJustReturn: []).drive(deck).disposed(by: disposeBag)
        let deal = scheduler.createObserver([Card].self)
        manager.deal.asDriver(onErrorJustReturn: []).drive(deal).disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(0, ())
        ]).bind(to: manager.newGame).disposed(by: disposeBag)
        // After adding cards 69 / 3 = 23 times, the deck should be empty
        let addCardsRepeatedly = (1...30).map({ time in
            return Recorded.next(time, ())
        })
        scheduler.createHotObservable(addCardsRepeatedly).bind(to: manager.addCards).disposed(by: disposeBag)
        scheduler.advanceTo(31)

        // Clear the first 3 cards
        let currentDeal = deal.events.last!.value.element!
        let set = Array(currentDeal[0...2])
        scheduler.createHotObservable([
            .next(40, set)
        ]).bind(to: manager.clearCards).disposed(by: disposeBag)
        scheduler.advanceTo(40)

        XCTAssertEqual(deck.events.last?.value.element?.count, 0)
        XCTAssertEqual(deal.events.last?.value.element?.count, 81 - 3)
    }
}
