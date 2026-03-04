////
//  NetworkClientTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

// MARK: - Mock URLProtocol

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler set")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - Test Endpoint

struct TestEndpoint: Endpoint {
    var path: String = "/articles/"
    var method: HTTPMethod = .get
    var parameters: [String: Any]? = nil
}

struct TestInvalidEndpoint: Endpoint {
    var baseURL: String = ""
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: [String: Any]? = nil
    var url: URL? { return nil }
}

// MARK: - Tests

class NetworkClientTests: XCTestCase {

    var session: URLSession!
    var sut: NetworkClient!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
    }

    override func tearDown() {
        session = nil
        sut = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    // MARK: - ServiceError from endpoint with nil URL

    func test_GivenEndpointWithNilURL_WhenRequest_ThenThrowsNotFountError() async {
        let client = NetworkClient()
        let endpoint = TestInvalidEndpoint()

        do {
            let _: ArticleListDTO = try await client.request(endpoint: endpoint)
            XCTFail("Se esperaba un error")
        } catch {
            XCTAssertTrue(error is ServiceError)
            XCTAssertEqual(error as? ServiceError, .notFountError)
        }
    }
}
