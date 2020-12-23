//
//  MockGameManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
@testable import Set
import SwiftMockObject
import Yoyo

enum MockGameManagerMethods {
    case newGame
    case addCards
    case selectCard
    case deselectCard
}

class MockGameManager: MockObject<MockGameManagerMethods>, GameManagerProtocol {
    let deck: Property<[Card]> = StoredProperty([])
    let deal: Property<[Card]> = StoredProperty([])

    let numberOfSetsFound: Property<Int> = StoredProperty(0)
    let numberOfSetsInDeal: Property<Int> = StoredProperty(0)

    func newGame() {
        _onMethod(.newGame)
    }

    func addCards() {
        _onMethod(.addCards)
    }

    func selectCard(atIndex index: Int) {
        _onMethod(.selectCard, args: index)
    }

    func deselectCard(atIndex index: Int) {
        _onMethod(.deselectCard, args: index)
    }
}
