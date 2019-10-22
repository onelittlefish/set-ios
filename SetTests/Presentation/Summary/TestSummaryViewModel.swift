//
//  TestSummaryViewModel.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject

class TestSummaryViewModel: XCTestCase {
    private var game: MockGameManager!

    private var model: SummaryViewModel!

    override func setUp() {
        game = MockGameManager()
        let container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SummaryViewModel(container: container)
    }

    func testCardsLeft() {
        game.deck = []
        XCTAssertEqual(model.cardsLeft, 0)
        game.deck = Card.allCards()
        XCTAssertEqual(model.cardsLeft, 81)
    }

}
