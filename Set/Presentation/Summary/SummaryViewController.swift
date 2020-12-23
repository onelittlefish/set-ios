//
//  SummaryViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import UIKit
import Yoyo

class SummaryViewController: UICollectionViewController {
    private let reuseIdentifier = "Cell"

    private var model: SummaryViewModel!

    private let updater = YoyoUpdater()

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

        updater.onTransition(model.stats) { [unowned self] _, _ in
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.stats.value.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let cellInfo = model.stats.value[indexPath.row]

        if let summaryCell = cell as? SummaryCollectionViewCell {
            summaryCell.label.text = cellInfo.label
            summaryCell.value.text = cellInfo.value
        }

        return cell
    }
}
