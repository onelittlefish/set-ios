//
//  CardGridViewModel.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI
import Swinject
import Yoyo

@available(iOS 13.0, *)
class CardGridViewModel: ObservableObject {
    @Published private(set) var deal: [Card] = []

    private let updater = YoyoUpdater()

    init(container: Container) {
        let game = container.resolve(GameManagerProtocol.self)!
        updater.bind(object: self, keyPath: \.deal, toProperty: game.deal)
    }
}
