//
//  TestSetViewModel.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject

class TestSetViewModel: XCTestCase {
    private var game: MockGameManager!

    private var model: SetViewModel!

    private var timesReloadCardsNotified = 0
    private var timesReloadSummaryNotified = 0

    override func setUp() {
        game = MockGameManager()
        let container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SetViewModel(container: container)

        timesReloadCardsNotified = 0
        timesReloadSummaryNotified = 0
        NotificationCenter.default.addObserver(self, selector: #selector(TestSetViewModel.reloadCards), name: model.reloadCards, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(TestSetViewModel.reloadSummary), name: model.reloadSummary, object: model)
    }

    @objc private func reloadCards() {
        timesReloadCardsNotified += 1
    }

    @objc private func reloadSummary() {
        timesReloadSummaryNotified += 1
    }

    func testAddCardsEnabled() {
        game.deck = []
        XCTAssertFalse(model.addCardsEnabled)
        game.deck = Card.allCards()
        XCTAssertTrue(model.addCardsEnabled)
    }

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

}
