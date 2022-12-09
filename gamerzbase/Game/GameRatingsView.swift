//
//  GameRatingsView.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import SwiftUI

struct GameRatingsView: View {
    @State var rating: GameRating

    var fireString: String {
        var fireString = ""
        for _ in 1...rating.numFires {
            fireString.append("🔥")
        }
        return fireString
    }

    var body: some View {
        VStack {
            Text(fireString)
            Text(String(rating.count))
                .font(.footnote)
                .monospacedDigit()
        }
    }
}
