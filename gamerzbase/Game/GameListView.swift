//
//  GameListView.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import SwiftUI

struct GameListView: View {
    @Binding var games: [Game]

    var body: some View {
        NavigationView {
            List(games) { game in
                NavigationLink(destination: GameDetailView(game: game)) {
                    HStack {
                        VStack {
                            Text(game.name)
                                .font(.headline)
                            Text(game.ratingString)
                                .font(.subheadline)
                        }
                        HStack {
                            ForEach(game.ratings.sorted { $0.numFires > $1.numFires }) { rating in
                                GameRatingsView(rating: rating)
                            }
                        }
                    }
                    .foregroundColor(.white)
                }
                .listRowBackground(
                    ZStack {
                        AsyncImage(
                            url: URL(string: game.backgroundImage ?? ""),
                            transaction: .init(animation: .easeInOut),
                            content: { phase in
                                switch phase {
                                case .empty:
                                    Text(game.backgroundImage ?? "Empty")
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 60)
                                        .clipped()
                                case .failure(let error):
                                    Text(error.localizedDescription)
                                @unknown default:
                                    Text(game.backgroundImage ?? "unknown default")
                                }
                            }
                        )
                        Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25))
                    }
                )
            }
        }
    }
}
