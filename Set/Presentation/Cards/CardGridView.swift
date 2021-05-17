//
//  CardGridView.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct CardGridView: View {
    @StateObject private var model = CardGridViewModel(container: SetContainer.container)

    var body: some View {
        ScrollView {
            let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
            LazyVGrid(columns: columns) {
                ForEach(model.deal, id: \.description) { card in
                    CardView(model: CardViewModel(container: SetContainer.container, card: card))
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct CardGridView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetContainer.container.resolve(GameManagerProtocol.self)!
        game.newGame()
        return CardGridView()
    }
}
