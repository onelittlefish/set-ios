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

    private var game = Game()
    private var selectedCards: [Card] = []

    private weak var summaryViewController: SummaryViewController!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

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

        reloadSummary()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let summaryViewController = segue.destination as? SummaryViewController {
            self.summaryViewController = summaryViewController
            summaryViewController.game = game
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func addCards() {
        game.dealMoreCards()

        collectionView.insertItems(at: [
            IndexPath(row: game.deal.count - 3, section: 0),
            IndexPath(row: game.deal.count - 2, section: 0),
            IndexPath(row: game.deal.count - 1, section: 0)
            ])
        collectionView.scrollToItem(
            at: IndexPath(row: game.deal.count - 1, section: 0),
            at: .bottom,
            animated: true
        )

        reloadSummary()
    }

    @objc func newGame() {
        game = Game()
        selectedCards = []

        collectionView.reloadSections(IndexSet(integer: 0))

        summaryViewController.game = game
        reloadSummary()
    }

    private func reloadSummary() {
        summaryViewController.collectionView?.reloadData()
        navigationItem.rightBarButtonItem?.isEnabled = game.deck.count > 0
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.deal.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.selectedCardBackgroundColor()

        if let cardCell = cell as? CardCollectionViewCell {
            let symbolView = CardSymbolView(frame: cell.bounds, card: game.deal[indexPath.row])
            symbolView.backgroundColor = .clear
            cardCell.cardSymbolView = symbolView
        }

        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCard = game.deal[indexPath.row]

        if !selectedCards.contains(selectedCard) {
            selectedCards.append(selectedCard)
        }

        if selectedCards.count == 3 {
            if game.handlePossibleSet(selectedCards) {
                selectedCards = []

                collectionView.reloadSections(IndexSet(integer: 0))

                reloadSummary()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedCards.firstIndex(of: game.deal[indexPath.row]) {
            selectedCards.remove(at: index)
        }
    }
}
