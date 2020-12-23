//
//  TestGame.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Yoyo

class TestGameManager: XCTestCase {
    private var deckManager: MockDeckManager!

    private var manager: GameManager!

    override func setUp() {
        deckManager = MockDeckManager()
        manager = GameManager(deckManager: deckManager)
    }

    func testDuplicateAndInvalidCardsSelected() {
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 10)
        manager.selectCard(atIndex: 2)

        MOAssertTimesCalled(deckManager.methodReference(.clearCards), 1)
        MOAssertArgumentEquals(deckManager.methodReference(.clearCards), 1, validSetAllDifferent())
        XCTAssertEqual(manager.numberOfSetsFound.value, 1)
    }

    func testDuplicateAndInvalidCardsDeselected() {
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()

        manager.selectCard(atIndex: 0)

        manager.deselectCard(atIndex: 0)
        manager.deselectCard(atIndex: 0)
        manager.deselectCard(atIndex: 10)

        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 2)

        MOAssertTimesCalled(deckManager.methodReference(.clearCards), 0)
        XCTAssertEqual(manager.numberOfSetsFound.value, 0)
    }

    func testSetSelected() {
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 2)

        MOAssertTimesCalled(deckManager.methodReference(.clearCards), 1)
        MOAssertArgumentEquals(deckManager.methodReference(.clearCards), 1, validSetAllDifferent())
        XCTAssertEqual(manager.numberOfSetsFound.value, 1)
    }

    func testNotASetSelected() {
        (deckManager.deal as! StoredProperty).value = invalidSet()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 2)

        MOAssertTimesCalled(deckManager.methodReference(.clearCards), 0)
        XCTAssertEqual(manager.numberOfSetsFound.value, 0)
    }

    func testCardDeselected1() {
        /*
         Deal out 6 cards (valid set * 2)
         Select 0, 1
         Deselect 0
         Select 2, 3

         Expectation: 1, 2, 3 is a valid set
         */
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent() + validSetAllDifferent()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.deselectCard(atIndex: 0)
        manager.selectCard(atIndex: 2)
        manager.selectCard(atIndex: 3)

        let expectedSet = [validSetAllDifferent()[1], validSetAllDifferent()[2], validSetAllDifferent()[0]]
        MOAssertArgumentEquals(deckManager.methodReference(.clearCards), 1, expectedSet)
    }

    func testCardDeselected2() {
        /*
         Deal out 6 cards (valid set + invalid set)
         Select 0, 1
         Deselect 0
         Select 2, 3, 0
         Deselect 3

         Expectation: 0, 1, 2 is a valid set
         */
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent() + invalidSet()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.deselectCard(atIndex: 0)
        manager.selectCard(atIndex: 2)
        manager.selectCard(atIndex: 3)
        manager.selectCard(atIndex: 0)
        manager.deselectCard(atIndex: 3)

        let expectedSet = [validSetAllDifferent()[1], validSetAllDifferent()[2], validSetAllDifferent()[0]]
        MOAssertArgumentEquals(deckManager.methodReference(.clearCards), 1, expectedSet)
    }

    func testSelectedCardsClearedAfterSetSelected() {
        /*
         Deal out 3 cards (valid set)
         Select set 0, 1, 2
         Deal out 3 different cards (valid set)
         Deselect 2
         Select 2

         Expectation: Deselecting and reselecting 2 should not count as a
         valid set since the 0, 1, 2 selection should have been cleared out.
         */
        deckManager.methodReference(.clearCards).setCustomBehavior({ [unowned self] _ in
            (self.deckManager.deal as! StoredProperty).value = validSetShapeDifferent()
        })
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 2)

        manager.deselectCard(atIndex: 2)
        manager.selectCard(atIndex: 2)

        MOAssertTimesCalled(deckManager.methodReference(.clearCards), 1)
    }

    func testNumberOfSetsFound() {
        /*
         Deal out 3 cards (valid set)
         Select set 0, 1, 2
         Wait for async setSelected event
         Add cards
         Start a new game
         */
        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()

        manager.selectCard(atIndex: 0)
        manager.selectCard(atIndex: 1)
        manager.selectCard(atIndex: 2)

        XCTAssertEqual(manager.numberOfSetsFound.value, 1)

        manager.addCards()
        manager.newGame()
        XCTAssertEqual(manager.numberOfSetsFound.value, 0)
    }

    func testNumberOfSets() {
        (deckManager.deal as! StoredProperty).value = invalidSet()
        XCTAssertEqual(manager.numberOfSetsInDeal.value, 0)

        (deckManager.deal as! StoredProperty).value = validSetAllDifferent()
        XCTAssertEqual(manager.numberOfSetsInDeal.value, 1)

        (deckManager.deal as! StoredProperty).value = threeSets()
        XCTAssertEqual(manager.numberOfSetsInDeal.value, 3)
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
