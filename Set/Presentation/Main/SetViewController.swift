//
//  SetViewController.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit

class SetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let reuseIdentifier = "Cell"

    private var model: SetViewModel!

    private var selectedCards: [Card] = []

    private weak var summaryViewController: SummaryViewController!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        model = SetViewModel(container: SetContainer.container)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
            target: self, action: #selector(SetViewController.newGame))
        navigationItem.leftBarButtonItem?.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
            target: self, action: #selector(SetViewController.addCards))
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

        NotificationCenter.default.addObserver(self, selector: #selector(SetViewController.reloadCards), name: model.reloadCards, object: model)
        NotificationCenter.default.addObserver(self, selector: #selector(SetViewController.reloadSummary), name: model.reloadSummary, object: model)

        model.newGame()
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

    @objc private func addCards() {
        model.addCards()

        collectionView.insertItems(at: [
            IndexPath(row: model.deal.count - 3, section: 0),
            IndexPath(row: model.deal.count - 2, section: 0),
            IndexPath(row: model.deal.count - 1, section: 0)
            ])
        collectionView.scrollToItem(
            at: IndexPath(row: model.deal.count - 1, section: 0),
            at: .bottom,
            animated: true
        )
    }

    @objc private func newGame() {
        model.newGame()
    }

    @objc private func reloadCards() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    @objc private func reloadSummary() {
        summaryViewController.collectionView?.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = model.addCardsEnabled
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.deal.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.selectedCardBackgroundColor()

        if let cardCell = cell as? CardCollectionViewCell {
            let symbolView = CardSymbolView(frame: cell.bounds, card: model.deal[indexPath.row])
            symbolView.backgroundColor = .clear
            cardCell.cardSymbolView = symbolView
        }

        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.selectCard(atIndex: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        model.deselectCard(atIndex: indexPath.row)
    }
}
