//
//  UIColor+Set.swift
//  Set
//
//  Copyright © 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func selectedCardBackgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray5
        } else {
            return UIColor(white: 0.9, alpha: 1)
        }
    }
}

extension Card.Color {
    var uiColor: UIColor {
        switch self {
        case .green:
            if #available(iOS 13.0, *) {
                return .systemGreen
            } else {
                return UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
            }
        case .purple:
            if #available(iOS 13.0, *) {
                return .systemPurple
            } else {
                return .purple
            }
        case .red:
            return .systemRed
        }
    }
}
