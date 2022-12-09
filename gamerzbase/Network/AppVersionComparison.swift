//
//  AppVersionComparison.swift
//  gamerzbase
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import Foundation
import SwiftUI

struct AppUpdateData: Codable {
    let version: String
}

struct AppVersionResults: Codable {
    let results: [AppUpdateData]
}

struct AppVersionComparison: CustomStringConvertible {
    // MARK: Internal for unit testing
    // store the latest app store version found so the user is only alerted when a newer verion is released
    @Storage(key: "last_version_checked", defaultValue: "0.0.0")
    var lastVersionChecked: String

    let currentVersionString: String
    let latestVersionString: String

    init(currentVersionString: String, latestVersionString: String) {
        self.currentVersionString = currentVersionString
        self.latestVersionString = latestVersionString
    }

    private func getCurrentVersionOctet(_ position: Int) -> Int {
        getVersion(from: currentVersionString, position: position)
    }

    private func getLatestVersionOctet(_ position: Int) -> Int {
        getVersion(from: latestVersionString, position: position)
    }

    private func getLastVersionOctet(_ position: Int) -> Int {
        getVersion(from: lastVersionChecked, position: position)
    }

    private var currentMajorVersion: Int {
        getCurrentVersionOctet(0)
    }

    private var currentMinorVersion: Int {
        getCurrentVersionOctet(1)
    }

    private var currentPatchVersion: Int {
        getCurrentVersionOctet(2)
    }

    private var latestMajorVersion: Int {
        getLatestVersionOctet(0)
    }

    private var latestMinorVersion: Int {
        getLatestVersionOctet(1)
    }

    private var latestPatchVersion: Int {
        getLatestVersionOctet(2)
    }

    private var lastCheckedMajorVersion: Int {
        getLastVersionOctet(0)
    }

    private var lastCheckedMinorVersion: Int {
        getLastVersionOctet(1)
    }

    private var lastCheckedPatchVersion: Int {
        getLastVersionOctet(2)
    }

    private var isLatestVersionGreaterThanCurrent: Bool {
        if latestMajorVersion > currentMajorVersion { return true }
        if latestMajorVersion == currentMajorVersion {
            if latestMinorVersion > currentMinorVersion { return true }
        }
        if latestMajorVersion == currentMajorVersion && latestMinorVersion == currentMinorVersion {
            if latestPatchVersion > currentPatchVersion { return true }
        }
        return false
    }

    private var isLatestVersionGreaterThanLastVersionChecked: Bool {
        if latestMajorVersion > lastCheckedMajorVersion { return true }
        if latestMajorVersion == lastCheckedMajorVersion {
            if latestMinorVersion > lastCheckedMinorVersion { return true }
        }
        if latestMajorVersion == lastCheckedMajorVersion && latestMinorVersion == lastCheckedMinorVersion {
            if latestPatchVersion > lastCheckedPatchVersion { return true }
        }
        return false
    }

    mutating func needsUpdate() -> Bool {
        guard isLatestVersionGreaterThanLastVersionChecked else { return false }
        lastVersionChecked = latestVersionString
        return isLatestVersionGreaterThanCurrent
    }


    private func getVersion(from string: String, position: Int) -> Int {
        let octets = string.components(separatedBy: ".")
        guard position < octets.count else { return 0 }
        return Int(octets[position]) ?? 0
    }
    // MARK: CustomStringConvertible
    var description: String {
        return
"""
    latest version checked: \(lastVersionChecked)
    current app version: \(currentVersionString)
    latest app store version: \(latestVersionString)
"""
    }

}

