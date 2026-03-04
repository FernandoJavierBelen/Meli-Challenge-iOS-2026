////
//  SpaceFlightEndpointTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class SpaceFlightEndpointTests: XCTestCase {

    // MARK: - baseURL & apiVersion (Endpoint protocol defaults)

    func test_GivenAnyEndpoint_WhenAccessingBaseURL_ThenReturnsExpectedURL() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: nil, offset: nil)
        XCTAssertEqual(endpoint.baseURL, "https://api.spaceflightnewsapi.net")
    }

    func test_GivenAnyEndpoint_WhenAccessingApiVersion_ThenReturnsV4() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: nil, offset: nil)
        XCTAssertEqual(endpoint.apiVersion, "v4")
    }

    // MARK: - listArticles

    func test_GivenListArticles_WhenAccessingPath_ThenReturnsArticlesPath() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: 10, offset: 0)
        XCTAssertEqual(endpoint.path, "/articles/")
    }

    func test_GivenListArticles_WhenAccessingMethod_ThenReturnsGET() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: 10, offset: 0)
        XCTAssertEqual(endpoint.method, .get)
    }

    func test_GivenListArticlesWithParams_WhenAccessingParameters_ThenReturnsLimitAndOffset() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: 20, offset: 5)
        let params = endpoint.parameters

        XCTAssertNotNil(params)
        XCTAssertEqual(params?["limit"] as? Int, 20)
        XCTAssertEqual(params?["offset"] as? Int, 5)
    }

    func test_GivenListArticlesWithNilParams_WhenAccessingParameters_ThenReturnsNil() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: nil, offset: nil)
        XCTAssertNil(endpoint.parameters)
    }

    func test_GivenListArticlesWithOnlyLimit_WhenAccessingParameters_ThenReturnsOnlyLimit() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: 10, offset: nil)
        let params = endpoint.parameters

        XCTAssertNotNil(params)
        XCTAssertEqual(params?["limit"] as? Int, 10)
        XCTAssertNil(params?["offset"])
    }

    func test_GivenListArticlesWithOnlyOffset_WhenAccessingParameters_ThenReturnsOnlyOffset() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: nil, offset: 5)
        let params = endpoint.parameters

        XCTAssertNotNil(params)
        XCTAssertNil(params?["limit"])
        XCTAssertEqual(params?["offset"] as? Int, 5)
    }

    func test_GivenListArticles_WhenAccessingURL_ThenURLContainsCorrectPathAndParams() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: 20, offset: 0)
        let url = endpoint.url

        XCTAssertNotNil(url)
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.contains("api.spaceflightnewsapi.net"))
        XCTAssertTrue(urlString.contains("/v4/articles/"))
        XCTAssertTrue(urlString.contains("limit=20"))
        XCTAssertTrue(urlString.contains("offset=0"))
    }

    func test_GivenListArticlesWithNilParams_WhenAccessingURL_ThenURLHasNoQueryItems() {
        let endpoint = SpaceFlightEndpoint.listArticles(limit: nil, offset: nil)
        let url = endpoint.url

        XCTAssertNotNil(url)
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.contains("/v4/articles/"))
        XCTAssertFalse(urlString.contains("limit"))
        XCTAssertFalse(urlString.contains("offset"))
    }

    // MARK: - searchArticles

    func test_GivenSearchArticles_WhenAccessingPath_ThenReturnsArticlesPath() {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: "SpaceX", limit: 10, offset: 0)
        XCTAssertEqual(endpoint.path, "/articles/")
    }

    func test_GivenSearchArticles_WhenAccessingMethod_ThenReturnsGET() {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: "SpaceX", limit: 10, offset: 0)
        XCTAssertEqual(endpoint.method, .get)
    }

    func test_GivenSearchArticlesWithAllParams_WhenAccessingParameters_ThenContainsSearchQueryLimitOffset() {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: "NASA", limit: 15, offset: 3)
        let params = endpoint.parameters

        XCTAssertNotNil(params)
        XCTAssertEqual(params?["search"] as? String, "NASA")
        XCTAssertEqual(params?["limit"] as? Int, 15)
        XCTAssertEqual(params?["offset"] as? Int, 3)
    }

    func test_GivenSearchArticlesWithNilLimitOffset_WhenAccessingParameters_ThenContainsOnlySearch() {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: "SpaceX", limit: nil, offset: nil)
        let params = endpoint.parameters

        XCTAssertNotNil(params)
        XCTAssertEqual(params?["search"] as? String, "SpaceX")
        XCTAssertNil(params?["limit"])
        XCTAssertNil(params?["offset"])
    }

    func test_GivenSearchArticles_WhenAccessingURL_ThenURLContainsSearchParam() {
        let endpoint = SpaceFlightEndpoint.searchArticles(query: "Mars", limit: 10, offset: 0)
        let url = endpoint.url

        XCTAssertNotNil(url)
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.contains("/v4/articles/"))
        XCTAssertTrue(urlString.contains("search=Mars"))
    }

    // MARK: - getArticleDetail

    func test_GivenGetArticleDetail_WhenAccessingPath_ThenReturnsArticleIdPath() {
        let endpoint = SpaceFlightEndpoint.getArticleDetail(id: 42)
        XCTAssertEqual(endpoint.path, "/articles/42/")
    }

    func test_GivenGetArticleDetail_WhenAccessingMethod_ThenReturnsGET() {
        let endpoint = SpaceFlightEndpoint.getArticleDetail(id: 42)
        XCTAssertEqual(endpoint.method, .get)
    }

    func test_GivenGetArticleDetail_WhenAccessingParameters_ThenReturnsNil() {
        let endpoint = SpaceFlightEndpoint.getArticleDetail(id: 42)
        XCTAssertNil(endpoint.parameters)
    }

    func test_GivenGetArticleDetail_WhenAccessingURL_ThenURLContainsArticleId() {
        let endpoint = SpaceFlightEndpoint.getArticleDetail(id: 99)
        let url = endpoint.url

        XCTAssertNotNil(url)
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.contains("/v4/articles/99/"))
        XCTAssertFalse(urlString.contains("?"))
    }

    // MARK: - HTTPMethod

    func test_GivenHTTPMethodGet_WhenAccessingRawValue_ThenReturnsGETString() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
    }
}
