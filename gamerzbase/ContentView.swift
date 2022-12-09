//
//  ContentView.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import SwiftUI
import Connectivium

struct ContentView: View {
    @State var games: [Game] = []
    @State var text: String = ""

    var body: some View {
        GameListView(games: $games)
            .onAppear {
                Task {
                    do {
                        let games = try await NetworkManager.getGames()
                        self.games = games
                    } catch {
                        text = error.localizedDescription
                    }
                }
            }
        Text(text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
