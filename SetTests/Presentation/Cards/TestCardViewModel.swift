//
//  TestCardViewModel.swift
//  SetTests
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import XCTest
@testable import Set
import Swinject
import SwiftUI

@available(iOS 13.0, *)
class TestCardViewModel: XCTestCase {
    private var container: Container!

    private var game: MockGameManager!

    private var model: CardViewModel!

    override func setUpWithError() throws {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = CardViewModel(
            container: container,
            card: Card(color: .green, number: .three, shape: .squiggle, fill: .lined)
        )
    }

    func testBorderColor() {
        XCTAssertEqual(model.borderColor, Color.gray)

        model.toggleSelected()
        XCTAssertEqual(model.borderColor, Color(UIColor.systemBlue))

        model.toggleSelected()
        XCTAssertEqual(model.borderColor, Color.gray)
    }

    func testBorderWidth() {
        XCTAssertEqual(model.borderWidth, 1)

        model.toggleSelected()
        XCTAssertEqual(model.borderWidth, 3)

        model.toggleSelected()
        XCTAssertEqual(model.borderWidth, 1)
    }

    func testToggleSelected() {
        model.toggleSelected()
        MOAssertTimesCalled(game.methodReference(.selectCard), 1)
        MOAssertTimesCalled(game.methodReference(.deselectCard), 0)

        model.toggleSelected()
        MOAssertTimesCalled(game.methodReference(.selectCard), 1)
        MOAssertTimesCalled(game.methodReference(.deselectCard), 1)
    }

}
