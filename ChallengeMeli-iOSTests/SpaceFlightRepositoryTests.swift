////
//  SpaceFlightRepositoryTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class SpaceFlightRepositoryTests: XCTestCase {

    var mockNetworkClient: MockNetworkClient!
    var repository: SpaceFlightRepository!

    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        repository = SpaceFlightRepository(networkClient: mockNetworkClient)
    }

    override func tearDown() {
        mockNetworkClient = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeFakeDetailDTO(id: Int = 1, title: String = "Test") -> ArticleDetailDTO {
        ArticleDetailDTO(
            id: id, title: title, authors: nil, url: "url",
            imageUrl: "img", newsSite: "Site", summary: "Summary",
            publishedAt: "2025-01-01T00:00:00Z", updatedAt: "2025-01-01T00:00:00Z",
            featured: false, events: nil
        )
    }

    private func makeFakeListDTO(articles: [ArticleDetailDTO]? = nil, next: String? = nil) -> ArticleListDTO {
        let results = articles ?? [makeFakeDetailDTO()]
        return ArticleListDTO(count: results.count, next: next, previous: nil, results: results)
    }

    // MARK: - listArticles

    func test_GivenSuccessfulResponse_WhenListArticles_ThenReturnsArticleListDTO() async throws {
        // Arrange
        let expectedDTO = makeFakeListDTO()
        mockNetworkClient.requestResult = expectedDTO

        // Act
        let result = try await repository.listArticles(limit: 10, offset: 0)

        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.results.first?.title, "Test")
        XCTAssertEqual(mockNetworkClient.requestCallCount, 1)
    }

    func test_GivenNetworkError_WhenListArticles_ThenThrowsError() async {
        // Arrange
        mockNetworkClient.requestError = ServiceError.conexionError

        // Act & Assert
        do {
            _ = try await repository.listArticles(limit: 10, offset: 0)
            XCTFail("Se esperaba un error")
        } catch {
            XCTAssertTrue(error is ServiceError)
        }
    }

    func test_GivenListArticles_WhenCalled_ThenUsesCorrectEndpoint() async throws {
        // Arrange
        mockNetworkClient.requestResult = makeFakeListDTO()

        // Act
        _ = try await repository.listArticles(limit: 20, offset: 5)

        // Assert
        XCTAssertEqual(mockNetworkClient.requestCallCount, 1)
        if let endpoint = mockNetworkClient.lastEndpoint as? SpaceFlightEndpoint {
            if case .listArticles(let limit, let offset) = endpoint {
                XCTAssertEqual(limit, 20)
                XCTAssertEqual(offset, 5)
            } else {
                XCTFail("Se esperaba endpoint .listArticles")
            }
        } else {
            XCTFail("El endpoint no es SpaceFlightEndpoint")
        }
    }

    // MARK: - searchArticles

    func test_GivenSuccessfulResponse_WhenSearchArticles_ThenReturnsArticleListDTO() async throws {
        // Arrange
        let expectedDTO = makeFakeListDTO(articles: [makeFakeDetailDTO(id: 10, title: "Search Result")])
        mockNetworkClient.requestResult = expectedDTO

        // Act
        let result = try await repository.searchArticles(query: "SpaceX", limit: 10, offset: 0)

        // Assert
        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results.first?.title, "Search Result")
        XCTAssertEqual(mockNetworkClient.requestCallCount, 1)
    }

    func test_GivenNetworkError_WhenSearchArticles_ThenThrowsError() async {
        // Arrange
        mockNetworkClient.requestError = ServiceError.notFountError

        // Act & Assert
        do {
            _ = try await repository.searchArticles(query: "test", limit: 10, offset: 0)
            XCTFail("Se esperaba un error")
        } catch {
            XCTAssertTrue(error is ServiceError)
            XCTAssertEqual(error as? ServiceError, .notFountError)
        }
    }

    func test_GivenSearchArticles_WhenCalled_ThenUsesCorrectEndpoint() async throws {
        // Arrange
        mockNetworkClient.requestResult = makeFakeListDTO()

        // Act
        _ = try await repository.searchArticles(query: "NASA", limit: 15, offset: 3)

        // Assert
        if let endpoint = mockNetworkClient.lastEndpoint as? SpaceFlightEndpoint {
            if case .searchArticles(let query, let limit, let offset) = endpoint {
                XCTAssertEqual(query, "NASA")
                XCTAssertEqual(limit, 15)
                XCTAssertEqual(offset, 3)
            } else {
                XCTFail("Se esperaba endpoint .searchArticles")
            }
        }
    }

    // MARK: - getArticleDetail

    func test_GivenSuccessfulResponse_WhenGetArticleDetail_ThenReturnsArticleDetailDTO() async throws {
        // Arrange
        let expectedDTO = makeFakeDetailDTO(id: 42, title: "Detail Article")
        mockNetworkClient.requestResult = expectedDTO

        // Act
        let result = try await repository.getArticleDetail(id: 42)

        // Assert
        XCTAssertEqual(result.id, 42)
        XCTAssertEqual(result.title, "Detail Article")
        XCTAssertEqual(mockNetworkClient.requestCallCount, 1)
    }

    func test_GivenNetworkError_WhenGetArticleDetail_ThenThrowsError() async {
        // Arrange
        mockNetworkClient.requestError = ServiceError.notFountError

        // Act & Assert
        do {
            _ = try await repository.getArticleDetail(id: 1)
            XCTFail("Se esperaba un error")
        } catch {
            XCTAssertTrue(error is ServiceError)
        }
    }

    func test_GivenGetArticleDetail_WhenCalled_ThenUsesCorrectEndpoint() async throws {
        // Arrange
        mockNetworkClient.requestResult = makeFakeDetailDTO(id: 99)

        // Act
        _ = try await repository.getArticleDetail(id: 99)

        // Assert
        if let endpoint = mockNetworkClient.lastEndpoint as? SpaceFlightEndpoint {
            if case .getArticleDetail(let id) = endpoint {
                XCTAssertEqual(id, 99)
            } else {
                XCTFail("Se esperaba endpoint .getArticleDetail")
            }
        }
    }
}
