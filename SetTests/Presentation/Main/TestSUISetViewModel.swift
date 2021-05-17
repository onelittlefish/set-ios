//
//  TestSUISetViewModel.swift
//  SetTests
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import Yoyo

@available(iOS 13.0, *)
class TestSUISetViewModel: XCTestCase {
    private var container: Container!

    private var game: MockGameManager!

    private var model: SUISetViewModel!

    override func setUpWithError() throws {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SUISetViewModel(container: container)
    }

    func testAddCardsDisabled() {
        (game.deck as! StoredProperty).value = Card.allCards
        XCTAssertFalse(model.addCardsDisabled)

        (game.deck as! StoredProperty).value = []
        XCTAssertTrue(model.addCardsDisabled)
    }

    func testAddCardsForegroundColor() {
        (game.deck as! StoredProperty).value = Card.allCards
        XCTAssertEqual(model.addCardsForegroundColor, .white)

        (game.deck as! StoredProperty).value = []
        XCTAssertEqual(model.addCardsForegroundColor, .white.opacity(0.5))
    }

}
