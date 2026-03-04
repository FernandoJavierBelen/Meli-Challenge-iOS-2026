////
//  ServiceErrorTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class ServiceErrorTests: XCTestCase {

    // MARK: - init with status code

    func test_GivenStatusCode400_WhenInitServiceError_ThenReturnsNotFountError() {
        let error = ServiceError(400)
        XCTAssertEqual(error, .notFountError)
    }

    func test_GivenStatusCode404_WhenInitServiceError_ThenReturnsNotFountError() {
        let error = ServiceError(404)
        XCTAssertEqual(error, .notFountError)
    }

    func test_GivenStatusCode500_WhenInitServiceError_ThenReturnsNotFountError() {
        let error = ServiceError(500)
        XCTAssertEqual(error, .notFountError)
    }

    func test_GivenStatusCode502_WhenInitServiceError_ThenReturnsNotFountError() {
        let error = ServiceError(502)
        XCTAssertEqual(error, .notFountError)
    }

    func test_GivenStatusCode503_WhenInitServiceError_ThenReturnsConexionError() {
        let error = ServiceError(503)
        XCTAssertEqual(error, .conexionError)
    }

    func test_GivenStatusCode200_WhenInitServiceError_ThenReturnsConexionError() {
        let error = ServiceError(200)
        XCTAssertEqual(error, .conexionError)
    }

    func test_GivenStatusCode399_WhenInitServiceError_ThenReturnsConexionError() {
        let error = ServiceError(399)
        XCTAssertEqual(error, .conexionError)
    }

    func test_GivenNilStatusCode_WhenInitServiceError_ThenReturnsConexionError() {
        let error = ServiceError(nil)
        XCTAssertEqual(error, .conexionError)
    }

    // MARK: - Equatable conformance

    func test_GivenTwoNotFountErrors_WhenCompared_ThenAreEqual() {
        let error1 = ServiceError.notFountError
        let error2 = ServiceError.notFountError
        XCTAssertEqual(error1, error2)
    }

    func test_GivenConexionAndNotFount_WhenCompared_ThenAreNotEqual() {
        let error1 = ServiceError.conexionError
        let error2 = ServiceError.notFountError
        XCTAssertNotEqual(error1, error2)
    }

    // MARK: - Error conformance

    func test_GivenServiceError_WhenUsedAsError_ThenConformsToErrorProtocol() {
        let error: Error = ServiceError.conexionError
        XCTAssertTrue(error is ServiceError)
    }
}
