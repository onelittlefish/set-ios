//
//  TestSUISummaryViewModel.swift
//  SetTests
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import Yoyo

@available(iOS 13.0, *)
class TestSUISummaryViewModel: XCTestCase {
    private var container: Container!

    private var game: MockGameManager!

    private var model: SUISummaryViewModel!

    override func setUpWithError() throws {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SUISummaryViewModel(container: container)
    }

    func testStats() {
        (game.numberOfSetsFound as! StoredProperty).value = 1
        (game.deck as! StoredProperty).value = Card.allCards
        (game.numberOfSetsInDeal as! StoredProperty).value = 3

        let stats1 = model.stats
        XCTAssertEqual(stats1[0].label, "Found")
        XCTAssertEqual(stats1[0].value, "1")
        XCTAssertEqual(stats1[1].label, "Left")
        XCTAssertEqual(stats1[1].value, "81")
        XCTAssertEqual(stats1[2].label, "Sets")
        XCTAssertEqual(stats1[2].value, "3")

        (game.numberOfSetsFound as! StoredProperty).value = 2
        (game.deck as! StoredProperty).value = []
        (game.numberOfSetsInDeal as! StoredProperty).value = 4

        let stats2 = model.stats
        XCTAssertEqual(stats2[0].label, "Found")
        XCTAssertEqual(stats2[0].value, "2")
        XCTAssertEqual(stats2[1].label, "Left")
        XCTAssertEqual(stats2[1].value, "0")
        XCTAssertEqual(stats2[2].label, "Sets")
        XCTAssertEqual(stats2[2].value, "4")
    }

}
