//
//  CardView.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct CardView: View {
    @ObservedObject var model: CardViewModel

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut.speed(2)) {
                model.toggleSelected()
            }
        }, label: {
            Group {
                CardSymbolViewWrapper(card: model.card)
                    .aspectRatio(1.75, contentMode: .fit)
                    .scaleEffect(0.85)
            }
        })
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(model.borderColor, lineWidth: model.borderWidth)
        )
        .padding(1)
    }
}

@available(iOS 13.0, *)
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(model: CardViewModel(
            container: SetContainer.container,
            card: Card(color: .green, number: .three, shape: .squiggle, fill: .lined)
        ))
    }
}
