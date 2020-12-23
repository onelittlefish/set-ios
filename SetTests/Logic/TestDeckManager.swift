//
//  TestDeckManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject

class TestDeckManager: XCTestCase {
    private var manager: DeckManager!

    override func setUp() {
        manager = DeckManager()
    }

    func testNewGame() {
        manager.newGame()
        XCTAssertEqual(manager.deck.value.count, 81 - 12)
        XCTAssertEqual(manager.deal.value.count, 12)

        manager.addCards()
        manager.newGame()
        XCTAssertEqual(manager.deck.value.count, 81 - 12)
        XCTAssertEqual(manager.deal.value.count, 12)
    }

    func testAddCards() {
        manager.newGame()
        manager.addCards()
        XCTAssertEqual(manager.deck.value.count, 81 - 12 - 3)
        XCTAssertEqual(manager.deal.value.count, 12 + 3)
    }

    func testAddCardsEmptyDeck() {
        manager.newGame()
        (1...30).forEach({ _ in
            manager.addCards()
        })

        XCTAssertEqual(manager.deck.value.count, 0)
        XCTAssertEqual(manager.deal.value.count, 81)
    }

    func testClearCards() {
        manager.newGame()

        // Clear the first 3 cards
        let firstDeal = manager.deal.value
        let set = Array(firstDeal[0...2])
        manager.clearCards(set)

        XCTAssertEqual(manager.deck.value.count, 81 - 12 - 3)
        XCTAssertEqual(manager.deal.value.count, 12)

        let secondDeal = manager.deal.value
        set.forEach({ XCTAssertFalse(secondDeal.contains($0), "Selected cards should be removed from deal") })
        secondDeal[0...2].forEach({ XCTAssertFalse(firstDeal.contains($0), "New cards should be added") })
        XCTAssertEqual(firstDeal.dropFirst(3), secondDeal.dropFirst(3), "New cards should be added in the positions of the selected cards")
    }

    func testClearInvalidCard() {
        manager.newGame()

        // Clear the first 3 cards + a card not in the deal
        let firstDeal = manager.deal.value
        let cardNotInDeal = manager.deck.value.last!
        let set = Array(firstDeal[0...2]) + [cardNotInDeal]
        manager.clearCards(set)

        XCTAssertEqual(manager.deck.value.count, 81 - 12 - 3)
        XCTAssertEqual(manager.deal.value.count, 12)

        let secondDeal = manager.deal.value
        set[0...2].forEach({ XCTAssertFalse(secondDeal.contains($0), "Selected cards should be removed from deal") })
        secondDeal[0...2].forEach({ XCTAssertFalse(firstDeal.contains($0), "New cards should be added") })
    }

    func testClearCardsMoreThan12CardsInDeal() {
        manager.newGame()
        manager.addCards()

        // Clear the first 3 cards
        let currentDeal = manager.deal.value
        let set = Array(currentDeal[0...2])
        manager.clearCards(set)

        XCTAssertEqual(manager.deck.value.count, 81 - 12 - 3, "More cards should not be dealt if deal already had more than 12")
        XCTAssertEqual(manager.deal.value.count, 12)
    }

    func testClearCardsEmptyDeck() {
        manager.newGame()
        (1...30).forEach({ _ in
            manager.addCards()
        })

        // Clear the first 3 cards
        let currentDeal = manager.deal.value
        let set = Array(currentDeal[0...2])
        manager.clearCards(set)

        XCTAssertEqual(manager.deck.value.count, 0)
        XCTAssertEqual(manager.deal.value.count, 81 - 3)
    }
}
