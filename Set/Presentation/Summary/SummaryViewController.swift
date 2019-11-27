//
//  SummaryViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SummaryViewController: UICollectionViewController {
    private let reuseIdentifier = "Cell"

    private var model: SummaryViewModel!

    private let disposeBag = DisposeBag()

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

        collectionView.dataSource = nil // Not sure what it setting this, maybe UICollectionViewController?
        model.stats.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: SummaryCollectionViewCell.self)) { _, element, cell in
            cell.label.text = element.label
            cell.value.text = element.value
        }.disposed(by: disposeBag)
    }
}
