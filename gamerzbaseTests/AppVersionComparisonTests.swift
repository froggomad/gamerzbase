//
//  gamerzbaseTests.swift
//  gamerzbaseTests
//
//  Created by Kenneth Dubroff on 12/4/22.
//

import XCTest
@testable import gamerzbase

class AppVersionComparisonTests: XCTestCase {
    func testNewMajorVersion_isLower() throws {
        let newVersionString = "1.9.9"
        let currentVersionString = "2.0.0"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertFalse(sut.needsUpdate())
    }

    func testNewMajorVersion_isHigher() throws {
        let newVersionString = "2.0.0"
        let currentVersionString = "1.9.9"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertTrue(sut.needsUpdate())
    }

    func testNewMinorVersion_isLower() throws {
        let newVersionString = "1.1.9"
        let currentVersionString = "1.2.0"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertFalse(sut.needsUpdate())
    }

    func testNewMinorVersion_isHigher() throws {
        let newVersionString = "1.2.0"
        let currentVersionString = "1.1.9"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertTrue(sut.needsUpdate())
    }

    func testNewPatchVersion_isLower() throws {
        let newVersionString = "1.0.1"
        let currentVersionString = "1.0.2"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertFalse(sut.needsUpdate())
    }

    func testNewPatchVersion_isHigher() throws {
        let newVersionString = "1.0.2"
        let currentVersionString = "1.0.1"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertTrue(sut.needsUpdate())
    }

    func testUpdate_OnlyTriggersOnce() {
        let newVersionString = "1.0.2"
        let currentVersionString = "1.0.1"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertTrue(sut.needsUpdate())
        // it was just checked with the same version, so the user shouldn't be disturbed
        XCTAssertFalse(sut.needsUpdate())
    }

    func testUpdate_TriggersAfterIgnored() {
        let newVersionString = "1.0.2"
        let currentVersionString = "1.0.1"
        var sut = sut(latestVersionString: newVersionString, currentVersionString: currentVersionString)
        XCTAssertTrue(sut.needsUpdate())
        // it was just checked with the same version, so the user shouldn't be disturbed
        XCTAssertFalse(sut.needsUpdate())
        var newSut = self.sut(latestVersionString: "1.0.3", currentVersionString: currentVersionString)
        newSut.lastVersionChecked = newVersionString
        // this is a newer version than the one previously checked, so it should prompt for an update
        XCTAssertTrue(newSut.needsUpdate())
    }

    private func sut(latestVersionString: String, currentVersionString: String) -> AppVersionComparison {
        var sut = AppVersionComparison(currentVersionString: currentVersionString, latestVersionString: latestVersionString)
        // reset UserDefaults
        sut.lastVersionChecked = "0.0.0"
        return sut
    }
}
