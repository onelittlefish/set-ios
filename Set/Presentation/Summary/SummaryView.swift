//
//  SummaryView.swift
//  Set
//
//  Copyright © 2021 Jihan. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SummaryView: View {
    @StateObject private var model = SUISummaryViewModel(container: SetContainer.container)

    var body: some View {
        HStack {
            ForEach(model.stats) { stat in
                createSummaryItem(label: stat.label, value: stat.value)
            }
        }
    }

    private func createSummaryItem(label: String, value: String) -> some View {
        VStack {
            Text(label)
            Text(value)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

@available(iOS 13.0, *)
struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
