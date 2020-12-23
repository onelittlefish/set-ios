//
//  TestSetViewModel.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import Yoyo

class TestSetViewModel: XCTestCase {
    private var container: Container!

    private var game: MockGameManager!

    private var model: SetViewModel!

    override func setUp() {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SetViewModel(container: container)
    }

    func testAddCardsEnabled() {
        (game.deck as! StoredProperty).value = Card.allCards()
        XCTAssertTrue(model.addCardsEnabled.value)

        (game.deck as! StoredProperty).value = []
        XCTAssertFalse(model.addCardsEnabled.value)
    }

    func testNewGame() {
        model.newGame()
        MOAssertTimesCalled(game.methodReference(.newGame), 1)
    }

    func testAddCards() {
        model.addCards()
        MOAssertTimesCalled(game.methodReference(.addCards), 1)
    }

    func testCardSelected() {
        model.selectCard(atIndex: 5)
        MOAssertArgumentEquals(game.methodReference(.selectCard), 1, 5)
    }

    func testCardDeselected() {
        model.deselectCard(atIndex: 5)
        MOAssertArgumentEquals(game.methodReference(.deselectCard), 1, 5)
    }
}
