//
//  SummaryViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import UIKit

class SummaryViewController: UICollectionViewController {
    private let reuseIdentifier = "Cell"

    private var model: SummaryViewModel!

    private enum Stat {
        case setsFound, cardsLeft, possibleSets
    }

    private typealias CellInfo = (type: Stat, label: String)

    private let cells: [CellInfo] = [
        (.setsFound, NSLocalizedString("Found", comment: "Label for number of sets found")),
        (.cardsLeft, NSLocalizedString("Left", comment: "Label for number of cards left")),
        (.possibleSets, NSLocalizedString("Sets", comment: "Label for number of sets in deal"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        model = SummaryViewModel(container: SetContainer.container)

        collectionView?.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let margin: CGFloat = 5
            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
            flowLayout.itemSize = CGSize(width: (view.bounds.size.width - margin * 4) / 3, height: 44)
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let cellInfo = cells[indexPath.row]

        let valueText: String
        switch cellInfo.type {
        case .setsFound:
            valueText = "\(model.numberOfSetsFound)"
        case .cardsLeft:
            valueText = "\(model.cardsLeft)"
        case .possibleSets:
            valueText = "\(model.numberOfSetsInDeal)"
        }

        if let summaryCell = cell as? SummaryCollectionViewCell {
            summaryCell.label.text = cellInfo.label
            summaryCell.value.text = valueText
        }

        return cell
    }

}
