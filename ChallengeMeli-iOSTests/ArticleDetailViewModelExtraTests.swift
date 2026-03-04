////
//  ArticleDetailViewModelExtraTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
import Combine
@testable import ChallengeMeli_iOS

@MainActor
class ArticleDetailViewModelExtraTests: XCTestCase {

    var mockUseCase: MockArticleDetailUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockArticleDetailUseCase()
        cancellables = []
    }

    override func tearDown() {
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeFakeArticle(
        id: Int = 1,
        title: String = "Test",
        newsSite: String = "Site",
        summary: String = "Summary",
        url: String = "https://test.com",
        imageUrl: String = "https://img.com/test.jpg",
        publishedAt: Date? = Date(),
        authors: [String] = ["Author"]
    ) -> ArticleModel {
        ArticleModel(
            id: id, title: title, imageUrl: imageUrl, newsSite: newsSite,
            summary: summary, url: url, publishedAt: publishedAt, authors: authors
        )
    }

    // MARK: - Computed properties with loaded article

    func test_GivenLoadedArticle_WhenAccessingSite_ThenReturnsUppercased() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        mockUseCase.executeResult = .success(makeFakeArticle(newsSite: "space news"))

        let exp = XCTestExpectation(description: "loaded")
        viewModel.$state
            .dropFirst()
            .sink { if case .loaded = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(viewModel.site, "SPACE NEWS")
    }

    func test_GivenLoadedArticle_WhenAccessingArticleURL_ThenReturnsValidURL() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        mockUseCase.executeResult = .success(makeFakeArticle(url: "https://example.com/article"))

        let exp = XCTestExpectation(description: "loaded")
        viewModel.$state
            .dropFirst()
            .sink { if case .loaded = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(viewModel.articleURL, URL(string: "https://example.com/article"))
    }

    func test_GivenLoadedArticle_WhenAccessingImageURL_ThenReturnsImageUrl() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        mockUseCase.executeResult = .success(makeFakeArticle(imageUrl: "https://img.com/photo.jpg"))

        let exp = XCTestExpectation(description: "loaded")
        viewModel.$state
            .dropFirst()
            .sink { if case .loaded = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(viewModel.imageURL, "https://img.com/photo.jpg")
    }

    func test_GivenLoadedArticleWithMultipleAuthors_WhenAccessingAuthors_ThenReturnsAllAuthors() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        mockUseCase.executeResult = .success(makeFakeArticle(authors: ["Alice", "Bob", "Charlie"]))

        let exp = XCTestExpectation(description: "loaded")
        viewModel.$state
            .dropFirst()
            .sink { if case .loaded = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(viewModel.authors, ["Alice", "Bob", "Charlie"])
    }

    func test_GivenLoadedArticleWithNilDate_WhenAccessingPublishedDate_ThenReturnsNil() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        mockUseCase.executeResult = .success(makeFakeArticle(publishedAt: nil))

        let exp = XCTestExpectation(description: "loaded")
        viewModel.$state
            .dropFirst()
            .sink { if case .loaded = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertNil(viewModel.publishedDate)
    }

    // MARK: - Error cases

    func test_GivenNotFountError_WhenLoadArticleDetail_ThenStateIsErrorNotFount() async {
        let viewModel = ArticleDetailViewModel(articleId: 999, useCase: mockUseCase)
        mockUseCase.executeResult = .failure(ServiceError.notFountError)

        let exp = XCTestExpectation(description: "error")
        viewModel.$state
            .dropFirst()
            .sink { if case .error = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        if case .error(let error) = viewModel.state {
            XCTAssertEqual(error, .notFountError)
        } else {
            XCTFail("Se esperaba state .error(.notFountError)")
        }
    }

    func test_GivenGenericError_WhenLoadArticleDetail_ThenStateIsConexionError() async {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        struct GenericError: Error {}
        mockUseCase.executeResult = .failure(GenericError())

        let exp = XCTestExpectation(description: "error")
        viewModel.$state
            .dropFirst()
            .sink { if case .error = $0 { exp.fulfill() } }
            .store(in: &cancellables)

        viewModel.loadArticleDetail()
        await fulfillment(of: [exp], timeout: 1.0)

        if case .error(let error) = viewModel.state {
            XCTAssertEqual(error, .conexionError)
        }
    }

    // MARK: - Initial state

    func test_GivenNewViewModel_WhenCreated_ThenStateIsIdle() {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        if case .idle = viewModel.state { } else {
            XCTFail("Se esperaba state .idle")
        }
    }

    func test_GivenNewViewModel_WhenCreated_ThenArticleIsNil() {
        let viewModel = ArticleDetailViewModel(articleId: 1, useCase: mockUseCase)
        XCTAssertNil(viewModel.article)
    }
}
