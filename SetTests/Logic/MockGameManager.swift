//
//  MockGameManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
@testable import Set
import SwiftMockObject

enum GameManagerProtocolMethods {
    case newGame
    case dealMoreCards
    case handlePossibleSet
}

class MockGameManager: MockObject<GameManagerProtocolMethods>, GameManagerProtocol {
    var deck: [Card] = []
    var deal: [Card] = []

    var numberOfSetsFound = 0
    var numberOfSetsInDeal = 0

    func newGame() {
        _onMethod(.newGame)
    }

    func dealMoreCards() {
        _onMethod(.dealMoreCards)
    }

    func handlePossibleSet(_ set: [Card]) -> Bool {
        return _onMethod(.handlePossibleSet, defaultReturn: true, args: set)
    }
}
