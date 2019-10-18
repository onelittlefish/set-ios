//
//  UIColor+Set.swift
//  Set
//
//  Copyright © 2015 Jihan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let navBarTintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
}

extension Card.Color {
    var uiColor: UIColor {
        switch self {
        case .green:
            return UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        case .purple:
            return .purple
        case .red:
            return .red
        }
    }
}
