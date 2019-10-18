//
//  CardCollectionCell.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    var cardSymbolView: CardSymbolView? {
        didSet {
            if let cardSymbolView = cardSymbolView {
                contentView.addSubview(cardSymbolView)
            }
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
        }
    }
}
