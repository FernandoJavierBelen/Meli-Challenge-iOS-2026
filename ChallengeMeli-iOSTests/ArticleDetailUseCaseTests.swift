//
//  ArticleDetailUseCaseTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class ArticleDetailUseCaseTests: XCTestCase {
    var mockRepository: MockSpaceFlightRepository!
    var useCase: ArticleDetailUseCase!

    override func setUp() {
        super.setUp()
        // Arrange
        mockRepository = MockSpaceFlightRepository()
        useCase = ArticleDetailUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_GivenSuccessfulDTO_WhenExecute_ThenReturnsCorrectArticleModel() async throws {
        // Arrange
        let fakeDTO = ArticleDetailDTO(
            id: 123,
            title: "Fake Article",
            authors: nil,
            url: "http://fake.url",
            imageUrl: "http://image",
            newsSite: "Fake Site",
            summary: "Fake Summary",
            publishedAt: "", updatedAt: "", featured: false, events: nil
        )
        
        mockRepository.getArticleDetailResult = .success(fakeDTO)
        
        // Act
        let model = try await useCase.execute(id: 123)
        
        // Assert
        XCTAssertEqual(model.id, 123)
        XCTAssertEqual(model.title, "Fake Article")
        XCTAssertEqual(model.summary, "Fake Summary")
        XCTAssertEqual(model.newsSite, "Fake Site")
    }
    
    func test_GivenNetworkError_WhenExecute_ThenThrowsError() async {
        // Arrange
        let expectedError = ServiceError.init(404)
        
        mockRepository.getArticleDetailResult = .failure(expectedError)
        
        // Act
        do {
            _ = try await useCase.execute(id: 404)
            XCTFail("El caso de uso debía lanzar un error, pero no lo hizo.")
        } catch {
            guard let networkError = error as? ServiceError else {
                XCTFail("El error no es del tipo NetworkError")
                return
            }
            XCTAssertEqual(networkError.localizedDescription, expectedError.localizedDescription)
        }
    }
}
