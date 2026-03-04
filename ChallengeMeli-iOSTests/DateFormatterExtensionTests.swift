////
//  DateFormatterExtensionTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class DateFormatterExtensionTests: XCTestCase {

    // MARK: - toSpaceFlightDate

    func test_GivenValidISO8601String_WhenConvertingToDate_ThenReturnsValidDate() {
        let dateString = "2025-10-30T14:30:00Z"
        let date = dateString.toSpaceFlightDate()
        XCTAssertNotNil(date)
    }

    func test_GivenValidISO8601String_WhenConvertingToDate_ThenDateComponentsAreCorrect() {
        let dateString = "2025-10-30T14:30:00Z"
        let date = dateString.toSpaceFlightDate()!

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: date)

        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 10)
        XCTAssertEqual(components.day, 30)
        XCTAssertEqual(components.hour, 14)
        XCTAssertEqual(components.minute, 30)
    }

    func test_GivenInvalidString_WhenConvertingToDate_ThenReturnsNil() {
        let dateString = "not-a-date"
        let date = dateString.toSpaceFlightDate()
        XCTAssertNil(date)
    }

    func test_GivenEmptyString_WhenConvertingToDate_ThenReturnsNil() {
        let dateString = ""
        let date = dateString.toSpaceFlightDate()
        XCTAssertNil(date)
    }

    func test_GivenDateOnlyString_WhenConvertingToDate_ThenReturnsNil() {
        let dateString = "2025-10-30"
        let date = dateString.toSpaceFlightDate()
        XCTAssertNil(date)
    }

    func test_GivenMidnightDate_WhenConvertingToDate_ThenReturnsValidDate() {
        let dateString = "2025-01-01T00:00:00Z"
        let date = dateString.toSpaceFlightDate()
        XCTAssertNotNil(date)
    }

    func test_GivenDifferentYear_WhenConvertingToDate_ThenReturnsCorrectYear() {
        let dateString = "2030-06-15T12:00:00Z"
        let date = dateString.toSpaceFlightDate()!

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: date)

        XCTAssertEqual(components.year, 2030)
        XCTAssertEqual(components.month, 6)
        XCTAssertEqual(components.day, 15)
    }

    // MARK: - ISO8601DateFormatter.spaceFlightFormatter

    func test_GivenSpaceFlightFormatter_WhenUsed_ThenIsSameInstance() {
        let formatter1 = ISO8601DateFormatter.spaceFlightFormatter
        let formatter2 = ISO8601DateFormatter.spaceFlightFormatter
        XCTAssertTrue(formatter1 === formatter2)
    }

    func test_GivenSpaceFlightFormatter_WhenFormattingDate_ThenOutputIsISO8601() {
        let formatter = ISO8601DateFormatter.spaceFlightFormatter
        let date = Date(timeIntervalSince1970: 0)
        let result = formatter.string(from: date)
        XCTAssertEqual(result, "1970-01-01T00:00:00Z")
    }
}
