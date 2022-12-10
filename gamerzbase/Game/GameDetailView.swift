//
//  GameDetailView.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/8/22.
//

import SwiftUI

struct GameDetailView: View {
    var game: Game
    @State var gameDetails: String = ""

    var body: some View {
        Text(gameDetails)
            .onAppear {
                Task {
                    let details = (try? await NetworkManager.getGameDetails(game.id).description) ?? "Error"
                    self.gameDetails = details
                }
            }
    }
}

//struct GameDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameDetailView()
//    }
//}
