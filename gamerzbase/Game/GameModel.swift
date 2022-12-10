//
//  GameModel.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import Foundation

struct GameContainer: Codable {
    let results: [Game]
}

struct Game: Codable, CustomStringConvertible, Identifiable {
    var ratingString: String {
        "\(rating) average rating out of \(ratings.map{$0.count}.reduce(0, +)) ratings"
    }
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double
    let ratings: [GameRating]
    let ratingsCount: Int?
    let reviewsTextCount: Int?
    let addedByStatus: AddedByStatus?
    let metacritic: Int
    let playtime: Int
    let suggestionsCount: Int?
    let requirementsEn: GameRequirements?
    let genres: [GameGenre]
    let stores: [GameStoreContainer]
    let tags: [GameTag]
    let esrbRating: ESRBRating?
    let shortScreenshots: [ShortScreenshot]?

    var description: String {
        let addedByStatus = addedByStatus?.description ?? ""
        let requirementsEn = requirementsEn?.description ?? ""
        return """
        name: \(name)
        rating:
        user ratings: \(ratings)
        \(addedByStatus)
        metacritic: \(metacritic)
        requirements: \(requirementsEn)
        genres: \(genres)
        stores: \(stores)
        tags: \(tags)
        ESRB Rating: \(esrbRating?.name ?? "none")
        screenshots: \(shortScreenshots?.count ?? 0)
        """
    }
}

struct GameDetails: Codable, Identifiable {
    let id: Int
    let description: String
}

struct GameRating: Codable, CustomStringConvertible, Identifiable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double

    var numFires: Int {
        switch self.title {
        case "skip":
            return 1
        case "meh":
            return 2
        case "recommended":
            return 3
        case "exceptional":
            return 4
        default: return 1
        }
    }

    var description: String {
"""
\(title):\(count)
"""
    }
}

struct AddedByStatus: Codable, CustomStringConvertible {
    let yet: Int
    let owned: Int
    let beaten: Int
    let toplay: Int
    let dropped: Int
    let playing: Int

    var description: String {
"""
owned by \(owned) players
beaten by \(beaten) players
currently being played by \(playing) players
"""
    }
}

struct GamePlatform: Codable, CustomStringConvertible {
    let id: Int
    let name: String
    let image: URL?
    let imageBackground: URL

    var description: String {
        name
    }
}

struct GameRequirements: Codable, CustomStringConvertible {
    let minimum: String
    let maximum: String

    var description: String {
"""
minimum requirements: \(minimum)
maximum requirements: \(maximum)
"""
    }
}

struct GameGenre: Codable, CustomStringConvertible {
    let id: Int
    let name: String
    let gamesCount: Int
    let imageBackground: URL

    var description: String {
        name
    }
}

struct GameStoreContainer: Codable, CustomStringConvertible {
    let id: Int
    let store: GameStore

    var description: String {
        store.name
    }
}

struct GameStore: Codable {
    let id: Int
    let name: String
    let domain: String?
    let gamesCount: Int
    let imageBackground: URL
}

struct GameTag: Codable, CustomStringConvertible {
    let id: Int
    let name: String
    let domain: String?
    let gamesCount: Int
    let imageBackground: URL

    var description: String {
        name
    }
}

struct ESRBRating: Codable, CustomStringConvertible {
    let id: Int
    let name: String

    var description: String {
        name
    }
}

struct ShortScreenshot: Codable, CustomStringConvertible {
    let id: Int
    let image: URL

    var description: String {
        image.absoluteString
    }
}
