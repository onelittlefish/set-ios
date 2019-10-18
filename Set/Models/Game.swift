//
//  Game.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation

class Game {

    private(set) var deck = Card.allCards()
    private(set) var deal: [Card] = []

    private(set) var numberOfSetsFound = 0
    private(set) var numberOfSetsInDeal = 0

    init() {
        shuffleDeck()
        deal = deal(12)
        numberOfSetsInDeal = numberOfSetsInDeal(deal)
    }

    func dealMoreCards() {
        deal.append(contentsOf: deal(3))
        numberOfSetsInDeal = numberOfSetsInDeal(deal)
    }

    func handlePossibleSet(_ set: [Card]) -> Bool {
        if isSet(set) {
            clearSet(set)
            return true
        }
        return false
    }

    // MARK: - Action helpers

    func isSet(_ set: [Card]) -> Bool {
        return set.count == 3 && thirdCardForSetWith(set[0], set[1]) == set[2]
    }

    private func clearSet(_ set: [Card]) {
        for card in set {
            guard let index = deal.firstIndex(of: card) else {
                assertionFailure("Tried to handle a set containing a card that is not present in the deal")
                return
            }

            deal.remove(at: index)
            if deal.count < 12 {
                let newDeal = deal(1)
                if !newDeal.isEmpty {
                    deal.insert(newDeal[0], at: index)
                }
            }
        }

        numberOfSetsFound += 1
        numberOfSetsInDeal = numberOfSetsInDeal(deal)
    }

    // MARK: - Deck helpers

    private func shuffleDeck() {
        deck.shuffle()
    }

    private func deal(_ numberToDeal: Int) -> [Card] {
        var deal = [Card]()
        for _ in 0..<numberToDeal {
            if deck.isEmpty {
                break
            }
            deal.append(deck.removeLast())
        }
        return deal
    }

    // MARK: - Set identification helpers

    private func thirdCardForSetWith(_ card1: Card, _ card2: Card) -> Card {
        let color = thirdProperty(fromList: Card.Color.allCases, formingSetWith: card1.color, card2.color)
        let number = thirdProperty(fromList: Card.Number.allCases, formingSetWith: card1.number, card2.number)
        let shape = thirdProperty(fromList: Card.Shape.allCases, formingSetWith: card1.shape, card2.shape)
        let fill = thirdProperty(fromList: Card.Fill.allCases, formingSetWith: card1.fill, card2.fill)
        return Card(color: color, number: number, shape: shape, fill: fill)
    }

    private func thirdProperty<T: Equatable>(fromList allProperties: [T], formingSetWith property1: T, _ property2: T) -> T {
        if property1 == property2 {
            return property1
        } else {
            assert(allProperties.count == 3, "List of possible values for property does not have 3 items")
            return allProperties.first(where: { $0 != property1 && $0 != property2 })!
        }
    }

    func numberOfSetsInDeal(_ deal: [Card]) -> Int {
        var numSets = 0
        for card1 in deal {
            for card2 in deal where card1 != card2 {
                let card3 = thirdCardForSetWith(card1, card2)
                if deal.contains(card3) {
                    numSets += 1
                }
            }
        }
        return numSets / 6
    }

    func test_setDeck(_ deck: [Card]) {
        self.deck = deck
    }

    func test_setDeal(_ deal: [Card]) {
        self.deal = deal
    }

}
