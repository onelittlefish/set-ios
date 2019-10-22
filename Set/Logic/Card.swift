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

    static func allCards() -> [Card] {
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
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.number == rhs.number &&
            lhs.shape == rhs.shape &&
            lhs.fill == rhs.fill
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
