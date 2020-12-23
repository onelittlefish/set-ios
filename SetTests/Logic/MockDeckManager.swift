//
//  MockDeckManager.swift
//  SetTests
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
@testable import Set
import SwiftMockObject
import Yoyo

enum MockDeckManagerMethods {
    case newGame
    case addCards
    case clearCards
}

class MockDeckManager: MockObject<MockDeckManagerMethods>, DeckManagerProtocol {
    let deck: Property<[Card]> = StoredProperty([])
    let deal: Property<[Card]> = StoredProperty([])

    func newGame() {
        _onMethod(.newGame)
    }

    func addCards() {
        _onMethod(.addCards)
    }

    func clearCards(_ cards: [Card]) {
        _onMethod(.clearCards, args: cards)
    }
}
