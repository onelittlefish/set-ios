//
//  Card.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation

struct Card {
    enum Color: String, CaseIterable {
        case red
        case green
        case purple
    }

    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }

    enum Shape: String, CaseIterable {
        case diamond
        case pill
        case squiggle
    }

    enum Fill: String, CaseIterable {
        case empty
        case lined
        case solid
    }

    let color: Color
    let number: Number
    let shape: Shape
    let fill: Fill

    static var allCards: [Card] = {
        var cards = [Card]()
        for color in Color.allCases {
            for number in Number.allCases {
                for shape in Shape.allCases {
                    for fill in Fill.allCases {
                        let card = Card(color: color, number: number, shape: shape, fill: fill)
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }()

    static func thirdCardForSetWith(_ card1: Card, _ card2: Card) -> Card {
        let color = thirdProperty(fromList: Card.Color.allCases, formingSetWith: card1.color, card2.color)
        let number = thirdProperty(fromList: Card.Number.allCases, formingSetWith: card1.number, card2.number)
        let shape = thirdProperty(fromList: Card.Shape.allCases, formingSetWith: card1.shape, card2.shape)
        let fill = thirdProperty(fromList: Card.Fill.allCases, formingSetWith: card1.fill, card2.fill)
        return Card(color: color, number: number, shape: shape, fill: fill)
    }

    private static func thirdProperty<T: Equatable>(fromList allProperties: [T], formingSetWith property1: T, _ property2: T) -> T {
        if property1 == property2 {
            return property1
        } else {
            assert(allProperties.count == 3, "List of possible values for property does not have 3 items")
            return allProperties.first(where: { $0 != property1 && $0 != property2 })!
        }
    }
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.number == rhs.number &&
            lhs.shape == rhs.shape &&
            lhs.fill == rhs.fill
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(number)
        hasher.combine(shape)
        hasher.combine(fill)
    }
}

extension Card: CustomStringConvertible {
    var description: String {
        return "<\(color), \(number), \(shape), \(fill)>"
    }
}

extension Card {
    init(coder aDecoder: NSCoder) {
        // swiftlint:disable force_cast
        color = aDecoder.decodeObject(forKey: "color") as! Color
        number = aDecoder.decodeObject(forKey: "number") as! Number
        shape = aDecoder.decodeObject(forKey: "shape") as! Shape
        fill = aDecoder.decodeObject(forKey: "fill") as! Fill
        // swiftlint:enable force_cast
    }

    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(color.rawValue, forKey: "color")
        aCoder.encode(number.rawValue, forKey: "number")
        aCoder.encode(shape.rawValue, forKey: "shape")
        aCoder.encode(fill.rawValue, forKey: "fill")
    }
}
