//
//  TestCard.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set

class TestCard: XCTestCase {

    func testInit() {
        let color = Card.Color.red
        let number = Card.Number.two
        let shape = Card.Shape.squiggle
        let fill = Card.Fill.lined

        let card = Card(color: color, number: number, shape: shape, fill: fill)

        XCTAssertEqual(card.color, color, "Wrong color")
        XCTAssertEqual(card.number, number, "Wrong number")
        XCTAssertEqual(card.shape, shape, "Wrong shape")
        XCTAssertEqual(card.fill, fill, "Wrong fill")
    }

    func testEquals() {
        let color = Card.Color.red
        let number = Card.Number.two
        let shape = Card.Shape.squiggle
        let fill = Card.Fill.lined

        let card1 = Card(color: color, number: number, shape: shape, fill: fill)
        let card2 = Card(color: color, number: number, shape: shape, fill: fill)

        XCTAssertEqual(card1, card2, "Cards should be equal")
    }

    func testNotEquals() {
        let color = Card.Color.red
        let number = Card.Number.two
        let shape = Card.Shape.squiggle

        let card1 = Card(color: color, number: number, shape: shape, fill: .lined)
        let card2 = Card(color: color, number: number, shape: shape, fill: .solid)

        XCTAssertNotEqual(card1, card2, "Cards should not be equal")
    }

    func testAllCards() {
        let allCards = Card.allCards()
        XCTAssertEqual(81, allCards.count)
    }

}
