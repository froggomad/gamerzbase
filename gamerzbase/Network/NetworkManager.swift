//
//  NetworkManager.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import Foundation
import Connectivium

extension Endpoint {
    static private let rawgBaseURL = "https://rawg-video-games-database.p.rapidapi.com"

    static var gamesEndpoint: Endpoint {
        constructRawgEndpoint("games")
    }

    static func gameDetailsEndpoint(for gameId: Int) -> Endpoint {
        constructRawgEndpoint(with: String(gameId), using: "games")
    }

    static var checkUpdate: Endpoint {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String ?? ""
        return Endpoint("https://itunes.apple.com/lookup?bundleId=\(bundleId)")
    }

    private static func constructRawgEndpoint(_ endpointString: String) -> Endpoint {
        return Endpoint("\(rawgBaseURL)/\(endpointString)".appendingRawgAPIKey())
    }
    
    private static func constructRawgEndpoint(with userInputString: String, using endpointString: String) -> Endpoint {
        let escapedText = userInputString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? userInputString
        return Endpoint("\(rawgBaseURL)/\(endpointString)/\(escapedText)".appendingRawgAPIKey())
    }


}

extension String {
    func appendingRawgAPIKey() -> String {
        self.appending("?key=\(NetworkManager.rawgAPIKey)")
    }
}

struct JSONError: Codable {
    var error: String
}

class NetworkManager {
    static let rawgAPIKey = "3220e8adf7464cedb2d4fd4d3fdb5fd5"
    static let rapidAPIKey = "1870132218mshda0696fff8c73f5p151e12jsne7bc40776c74"
    static private let rawgHeaders = [
        "X-RapidAPI-Key": rapidAPIKey,
        "X-RapidAPI-Host": "rawg-video-games-database.p.rapidapi.com"
    ]
    static private let decoder = JSONDecoder()

    static func get(endpoint: Endpoint, headers: [String: String] = rawgHeaders) async throws -> Data {
        try await Connectivium.get(endpoint, headers: headers)
    }

    static func getGames() async throws -> [Game] {
        let data = try await get(endpoint: .gamesEndpoint, headers: rawgHeaders)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let results = try decoder.decode(GameContainer.self, from: data)
        return results.results
    }

    static func getGameDetails(_ id: Int) async throws -> GameDetails {
        let data = try await get(endpoint: .gameDetailsEndpoint(for: id))
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(GameDetails.self, from: data)
        return decoded
    }

    static func needsUpdate() async throws -> AppVersionComparison {
        let data = try await get(endpoint: .checkUpdate)
        let noResultsError: NSError = NSError(domain: #function, code: 999, userInfo: [NSLocalizedDescriptionKey: "No results"])
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(AppVersionResults.self, from: data)
            guard decoded.results.count > 0 else { throw noResultsError }

            guard let currentVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                throw noResultsError
            }

            let appVersionComparison = AppVersionComparison(currentVersionString: currentVersionString, latestVersionString: decoded.results[0].version)
            print(appVersionComparison)

            return  appVersionComparison
        }
    }
}
