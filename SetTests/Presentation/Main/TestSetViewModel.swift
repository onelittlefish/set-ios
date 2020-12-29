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

    private var timesReloadCardsCalled: Int!
    private var cardsAddedIndexPaths: [[IndexPath]]!
    private var cardsRemovedIndexPaths: [[IndexPath]]!
    private var cardsReplacedIndexPaths: [[IndexPath]]!

    override func setUp() {
        game = MockGameManager()
        container = Container { container in
            container.register(GameManagerProtocol.self) { [unowned self] _ in self.game }
        }
        model = SetViewModel(container: container)

        timesReloadCardsCalled = 0
        cardsAddedIndexPaths = []
        cardsRemovedIndexPaths = []
        cardsReplacedIndexPaths = []

        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards), name: .SetViewModelReloadAllCards, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsAdded(notif:)), name: .SetViewModelCardsAdded, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsRemoved(notif:)), name: .SetViewModelCardsRemoved, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsReplaced(notif:)), name: .SetViewModelCardsReplaced, object: model)
    }

    @objc private func reloadCards() {
        timesReloadCardsCalled += 1
    }

    @objc private func cardsAdded(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        cardsAddedIndexPaths.append(indexPaths)
    }

    @objc private func cardsRemoved(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        cardsRemovedIndexPaths.append(indexPaths)
    }

    @objc private func cardsReplaced(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        cardsReplacedIndexPaths.append(indexPaths)
    }

    func testAddCardsEnabled() {
        (game.deck as! StoredProperty).value = Card.allCards
        XCTAssertTrue(model.addCardsEnabled.value)

        (game.deck as! StoredProperty).value = []
        XCTAssertFalse(model.addCardsEnabled.value)
    }

    func testNewGameNotification() {
        game.methodReference(.newGame).setCustomBehavior({ [unowned self] _ in
            (self.game.deal as! StoredProperty).value = Array(Card.allCards[0..<12])
        })

        model.newGame()

        XCTAssertEqual(timesReloadCardsCalled, 1)
    }

    func testReplaceCardsNotification() {
        var deal = Array(Card.allCards[0..<12])
        (game.deal as! StoredProperty).value = deal

        // Replace three cards in the deal; this simulates adding new cards after clearing a set
        deal[0] = Card.allCards[12]
        deal[6] = Card.allCards[13]
        deal[11] = Card.allCards[14]
        (game.deal as! StoredProperty).value = deal

        XCTAssertEqual(cardsReplacedIndexPaths.count, 1)
        XCTAssertEqual(cardsReplacedIndexPaths.first?.map({ $0.item }).sorted(), [ 0, 6, 11 ])
    }

    func testAddCardsNotification() {
        game.methodReference(.newGame).setCustomBehavior({ [unowned self] _ in
            (self.game.deal as! StoredProperty).value = Array(Card.allCards[0..<12])
        })
        model.newGame()

        (game.deal as! StoredProperty).value = Array(Card.allCards[0..<15])

        XCTAssertEqual(cardsAddedIndexPaths.count, 1)
        XCTAssertEqual(cardsAddedIndexPaths.first?.map({ $0.item }).sorted(), [ 12, 13, 14 ])
    }

    func testRemoveCardsNotification() {
        var deal = Array(Card.allCards[0..<15])
        (game.deal as! StoredProperty).value = deal

        // Remove three cards from the deal; this simulates clearing a set when there are more than 12 cards in the deal (or the deck is empty)
        deal.remove(at: 3)
        deal.removeFirst()
        deal.removeLast()
        (game.deal as! StoredProperty).value = deal

        XCTAssertEqual(cardsRemovedIndexPaths.count, 1)
        XCTAssertEqual(cardsRemovedIndexPaths.first?.map({ $0.item }).sorted(), [ 0, 3, 14 ])
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
