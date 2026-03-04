//
//  ArticleDetailViewModelTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
import Combine
@testable import ChallengeMeli_iOS

@MainActor
class ArticleDetailViewModelTests: XCTestCase {

    var mockUseCase: MockArticleDetailUseCase!
    var viewModel: ArticleDetailViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockArticleDetailUseCase()
        viewModel = ArticleDetailViewModel(
            articleId: 1,
            useCase: mockUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeFakeArticle(id: Int = 1, title: String = "Test Article") -> ArticleModel {
        ArticleModel(
            id: id,
            title: title,
            imageUrl: "",
            newsSite: "",
            summary: "",
            url: "",
            publishedAt: Date(),
            authors: ["Test Author"]
        )
    }

    // MARK: - loadArticleDetail

    func test_GivenSuccessfulLoad_WhenLoadArticleDetail_ThenStateIsLoaded() async {
        // Arrange
        mockUseCase.executeResult = .success(makeFakeArticle(title: "Success Article"))

        let expectation = XCTestExpectation(description: "state cambia a .loaded")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.loadArticleDetail()

        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        if case .loaded = viewModel.state { } else {
            XCTFail("Se esperaba state == .loaded, pero se obtuvo: \(viewModel.state)")
        }
        XCTAssertEqual(viewModel.article?.id, 1)
        XCTAssertEqual(viewModel.article?.title, "Success Article")
    }

    func test_GivenServiceError_WhenLoadArticleDetail_ThenStateIsError() async {
        // Arrange
        mockUseCase.executeResult = .failure(ServiceError.conexionError)

        let expectation = XCTestExpectation(description: "state cambia a .error")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.loadArticleDetail()

        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        if case .error = viewModel.state { } else {
            XCTFail("Se esperaba state == .error, pero se obtuvo: \(viewModel.state)")
        }
        XCTAssertNil(viewModel.article)
    }

    func test_GivenLoadingState_WhenLoadArticleDetailCalledTwice_ThenFetchOnlyOnce() async {
        // Arrange
        mockUseCase.executeResult = .success(makeFakeArticle())

        let expectation = XCTestExpectation(description: "state cambia a .loaded")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()

        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    // MARK: - Computed properties

    func test_GivenLoadedArticle_WhenAccessingComputedProperties_ThenValuesAreCorrect() async {
        // Arrange
        mockUseCase.executeResult = .success(makeFakeArticle(title: "Computed Test"))

        let expectation = XCTestExpectation(description: "state cambia a .loaded")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state { expectation.fulfill() }
            }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.title, "Computed Test")
        XCTAssertEqual(viewModel.authors, ["Test Author"])
        XCTAssertNotNil(viewModel.publishedDate)
    }

    func test_GivenNoArticle_WhenAccessingComputedProperties_ThenDefaultValuesAreReturned() {
        // No se llama a loadArticleDetail → article es nil
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.summary, "")
        XCTAssertEqual(viewModel.site, "")
        XCTAssertEqual(viewModel.authors, [])
        XCTAssertNil(viewModel.publishedDate)
        XCTAssertNil(viewModel.imageURL)
        XCTAssertNil(viewModel.articleURL)
    }
}
