//
//  TestGame.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set

class TestGame: XCTestCase {

    func testIsSet() {
        let game = Game()

        XCTAssertTrue(game.isSet(validSetAllDifferent()), "Should be a set")
        XCTAssertTrue(game.isSet(validSetShapeDifferent()), "Should be a set")

        XCTAssertFalse(game.isSet(invalidSet()), "Should not be a set")
        XCTAssertFalse(game.isSet(threeSets()), "Should not be a set")
    }

    func testNumberOfSets() {
        let game = Game()

        XCTAssertEqual(game.numberOfSetsInDeal(invalidSet()), 0, "Expected no sets")
        XCTAssertEqual(game.numberOfSetsInDeal(validSetAllDifferent()), 1, "Expected one set")
        XCTAssertEqual(game.numberOfSetsInDeal(threeSets()), 3, "Expected three sets")
    }

    func testDealMoreCards() {
        let game = Game()
        let initialNumberOfSets = game.numberOfSetsInDeal
        XCTAssertEqual(game.deck.count, 69, "Deck size")
        XCTAssertEqual(game.deal.count, 12, "Deal size")

        game.test_setDeck(validSetAllDifferent()) // Deck now has 3 cards
        game.dealMoreCards()

        XCTAssertEqual(game.deck.count, 0, "Deck size")
        XCTAssertEqual(game.deal.count, 15, "Deal size")
        XCTAssertGreaterThan(game.numberOfSetsInDeal, initialNumberOfSets, "Number of sets did not update")
    }

    func testHandlePossibleSet() {
        let game = Game()

        // Ensure deal has a known set
        let dealSet = validSetShapeDifferent()
        var deal = game.deal
        deal.replaceSubrange(0...2, with: dealSet)
        game.test_setDeal(deal)

        XCTAssertTrue(game.handlePossibleSet(dealSet))
        XCTAssertEqual(game.deal.count, 12, "New cards should be dealt")
        XCTAssertEqual(game.numberOfSetsFound, 1, "Number of sets did not update")
    }

    func testHandlePossibleSetNoDeal() {
        let game = Game()

        // Ensure deck will deal out a known set
        // Assuming cards will be dealt from the end of the deck
        let deckSet = validSetAllDifferent()
        var deck = game.deck
        deck.append(contentsOf: deckSet)
        game.test_setDeck(deck)

        game.dealMoreCards()
        XCTAssertEqual(game.deal.count, 15, "New cards should be dealt")

        XCTAssertTrue(game.handlePossibleSet(deckSet))
        XCTAssertEqual(game.deal.count, 12, "New cards should be dealt")
        XCTAssertEqual(game.numberOfSetsFound, 1, "Number of sets did not update")
    }

    func testHandlePossibleSetEmptyDeck() {
        let game = Game()

        // Ensure deal has a known set
        let dealSet = validSetShapeDifferent()
        var deal = game.deal
        deal.replaceSubrange(0...2, with: dealSet)
        game.test_setDeal(deal)

        // Empty deck
        game.test_setDeck([])

        XCTAssertTrue(game.handlePossibleSet(dealSet))
        XCTAssertEqual(game.deal.count, 9, "No more cards should be dealt")
        XCTAssertEqual(game.numberOfSetsFound, 1, "Number of sets did not update")
    }

    // Helpers

    func validSetAllDifferent() -> [Card] {
        return [
            Card(color: .red, number: .one, shape: .squiggle, fill: .lined),
            Card(color: .green, number: .two, shape: .pill, fill: .empty),
            Card(color: .purple, number: .three, shape: .diamond, fill: .solid)
        ]
    }

    func validSetShapeDifferent() -> [Card] {
        let color = Card.Color.purple
        let number = Card.Number.one
        let fill = Card.Fill.lined

        return [
            Card(color: color, number: number, shape: .squiggle, fill: fill),
            Card(color: color, number: number, shape: .pill, fill: fill),
            Card(color: color, number: number, shape: .diamond, fill: fill)
        ]
    }

    func invalidSet() -> [Card] {
        return [
            Card(color: .green, number: .one, shape: .squiggle, fill: .solid),
            Card(color: .green, number: .one, shape: .pill, fill: .solid),
            Card(color: .green, number: .three, shape: .diamond, fill: .solid)
        ]
    }

    func threeSets() -> [Card] {
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
