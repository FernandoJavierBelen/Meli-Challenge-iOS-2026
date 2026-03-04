////
//  SearchArticlesUseCaseTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//  
//

import XCTest
@testable import ChallengeMeli_iOS

class SearchArticlesUseCaseTests: XCTestCase {

    var mockRepository: MockSpaceFlightRepository!
    var useCase: SearchArticlesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockSpaceFlightRepository()
        useCase = SearchArticlesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_GivenSuccessfulDTO_WhenExecute_ThenReturnsCorrectResponseModel() async throws {
        // Arrange
        let fakeDetailDTO = ArticleDetailDTO(
            id: 10, title: "Search Article", authors: nil, url: "", imageUrl: "",
            newsSite: "Search Site", summary: "Search Summary", publishedAt: "",
            updatedAt: "", featured: false, events: nil
        )
        let fakeListDTO = ArticleListDTO(
            count: 1, next: nil, previous: nil, results: [fakeDetailDTO]
        )
        mockRepository.searchArticlesResult = .success(fakeListDTO)
        
        // Act
        let responseModel = try await useCase.execute(query: "test", limit: 10, offset: 0)
        
        // Assert
        XCTAssertEqual(responseModel.count, 1)
        XCTAssertNil(responseModel.next)
        XCTAssertEqual(responseModel.articles.count, 1)
        XCTAssertEqual(responseModel.articles.first?.title, "Search Article")
    }
    
    func test_GivenNetworkError_WhenExecute_ThenThrowsError() async {
        // Arrange
        let expectedError = ServiceError.init(404)
        mockRepository.searchArticlesResult = .failure(expectedError)
        
        // Act y Assert
        do {
            _ = try await useCase.execute(query: "test", limit: 10, offset: 0)
            XCTFail("El caso de uso debía lanzar un error, pero no lo hizo.")
        } catch {
            XCTAssertTrue(error is ServiceError)
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}
