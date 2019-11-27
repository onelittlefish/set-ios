//
//  SetViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SetViewController: UIViewController, UICollectionViewDelegate {
    private let reuseIdentifier = "Cell"

    private var model: SetViewModel!

    private var selectedCards: [Card] = []

    private weak var summaryViewController: SummaryViewController!

    @IBOutlet weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        model = SetViewModel(container: SetContainer.container)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .white

        edgesForExtendedLayout = UIRectEdge()

        // Cards
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.allowsMultipleSelection = true

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let margin: CGFloat = 5
            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
            flowLayout.itemSize = CGSize(width: (view.bounds.size.width - margin * 4) / 3, height: 70)
        }

        // Bindings

        navigationItem.leftBarButtonItem?.rx.tap.bind(to: model.newGame).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem?.rx.tap.bind(to: model.addCards).disposed(by: disposeBag)

        collectionView.rx.itemSelected.bind(to: model.cardSelected).disposed(by: disposeBag)
        collectionView.rx.itemDeselected.bind(to: model.cardDeselected).disposed(by: disposeBag)

        model.addCardsEnabled.bind(to: navigationItem.rightBarButtonItem!.rx.isEnabled).disposed(by: disposeBag)

        model.deal.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: CardCollectionViewCell.self)) { _, element, cell in
            cell.selectedBackgroundView = UIView(frame: cell.frame)
            cell.selectedBackgroundView?.backgroundColor = UIColor.selectedCardBackgroundColor()

            let symbolView = CardSymbolView(frame: cell.bounds, card: element)
            symbolView.backgroundColor = .clear
            cell.cardSymbolView = symbolView
        }.disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let summaryViewController = segue.destination as? SummaryViewController {
            self.summaryViewController = summaryViewController
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
