//
//  SummaryCollectionViewCell.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {
    private(set) weak var label: UILabel!
    private(set) weak var value: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        self.label = label

        let value = UILabel(frame: .zero)
        value.textAlignment = .center
        value.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(value)
        self.value = value

        NSLayoutConstraint.activate(constraintsForLabel(label))
        NSLayoutConstraint.activate(constraintsForValue(value, relativeToLabel: label))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func constraintsForLabel(_ label: UILabel) -> [NSLayoutConstraint] {
        return [
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
    }

    private func constraintsForValue(_ value: UILabel, relativeToLabel label: UILabel) -> [NSLayoutConstraint] {
        return [
            value.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            value.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            value.topAnchor.constraint(equalTo: label.bottomAnchor),
            value.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
    }

}
