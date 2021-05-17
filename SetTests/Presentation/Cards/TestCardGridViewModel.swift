//
//  TestCardGridViewModel.swift
//  SetTests
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import Yoyo

@available(iOS 13.0, *)
class TestCardGridViewModel: XCTestCase {
    private var container: Container!

    private var game: MockGameManager!

    private var model: CardGridViewModel!

    override func setUpWithError() throws {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = CardGridViewModel(container: container)
    }

    func testDeal() {
        (game.deal as! StoredProperty).value = Card.allCards
        XCTAssertEqual(model.deal, Card.allCards)
    }

}
