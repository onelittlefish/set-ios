//
//  SetView.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct SetView: View {
    @StateObject private var model = SUISetViewModel(container: SetContainer.container)

    init() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = .systemBlue
    }

    var body: some View {
        let newGameButton = Button(action: {
            withAnimation {
                model.newGame()
            }
        }, label: {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
                .foregroundColor(.white)
        })
        .accessibilityLabel(Text("New Game"))

        let addCardsButton = Button(action: {
            withAnimation {
                model.addCards()
            }
        }, label: {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(model.addCardsForegroundColor)
        })
        .disabled(model.addCardsDisabled)
        .accessibilityLabel(Text("Add Cards"))

        return NavigationView {
            VStack {
                SummaryView()
                CardGridView()
            }
            .padding()
            .navigationBarTitle("Set", displayMode: .inline)
            .navigationBarItems(leading: newGameButton, trailing: addCardsButton)
        }
    }
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
