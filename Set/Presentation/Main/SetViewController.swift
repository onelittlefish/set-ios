//
//  SetViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit
import Yoyo

class SetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let reuseIdentifier = "Cell"

    private var model: SetViewModel!

    private var selectedCards: [Card] = []

    private weak var summaryViewController: SummaryViewController!

    @IBOutlet weak var collectionView: UICollectionView!

    private let updater = YoyoUpdater()

    override func viewDidLoad() {
        super.viewDidLoad()

        model = SetViewModel(container: SetContainer.container)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newGame))
        navigationItem.leftBarButtonItem?.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCards))
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

        updater.bind(object: navigationItem.rightBarButtonItem!, keyPath: \.isEnabled, toProperty: model.addCardsEnabled)

        model.newGame()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards), name: .SetViewModelReloadAllCards, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsAdded(notif:)), name: .SetViewModelCardsAdded, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsRemoved(notif:)), name: .SetViewModelCardsRemoved, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(cardsReplaced(notif:)), name: .SetViewModelCardsReplaced, object: model)
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

    @objc private func newGame() {
        model.newGame()
    }

    @objc private func addCards() {
        model.addCards()
    }

    @objc private func reloadCards() {
        collectionView.reloadData()
    }

    @objc private func cardsAdded(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        collectionView.insertItems(at: indexPaths)
        collectionView.scrollToItem(at: IndexPath(item: model.deal.value.count - 1, section: 0), at: .bottom, animated: true)
    }

    @objc private func cardsRemoved(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        collectionView.deleteItems(at: indexPaths)
    }

    @objc private func cardsReplaced(notif: Notification) {
        guard let indexPaths = notif.userInfo?["indexPaths"] as? [IndexPath] else { return }
        collectionView.reloadItems(at: indexPaths)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.deal.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.selectedCardBackgroundColor()

        if let cardCell = cell as? CardCollectionViewCell {
            let symbolView = CardSymbolView(frame: cell.bounds, card: model.deal.value[indexPath.row])
            symbolView.backgroundColor = .clear
            cardCell.cardSymbolView = symbolView
        }

        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.selectCard(atIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        model.deselectCard(atIndex: indexPath.item)
    }
}
