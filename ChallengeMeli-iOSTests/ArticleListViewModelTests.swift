//
//  ArticleListViewModelTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
import Combine
@testable import ChallengeMeli_iOS

@MainActor
class ArticleListViewModelTests: XCTestCase {
    var mockListUseCase: MockListArticlesUseCase!
    var mockSearchUseCase: MockSearchArticlesUseCase!
    var viewModel: ArticleListViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockListUseCase = MockListArticlesUseCase()
        mockSearchUseCase = MockSearchArticlesUseCase()
        viewModel = ArticleListViewModel(listUseCase: mockListUseCase,
                                         searchUseCase: mockSearchUseCase)
        cancellables = []
    }

    override func tearDown() {
        mockListUseCase = nil
        mockSearchUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeFakeResponse(id: Int = 1, title: String, next: String? = nil) -> ArticleResponseModel {
        let fakeDetailDTO = ArticleDetailDTO(
            id: id,
            title: title,
            authors: nil,
            url: "",
            imageUrl: "",
            newsSite: "Test Site",
            summary: "Test Summary",
            publishedAt: "",
            updatedAt: "",
            featured: false,
            events: nil
        )
        let fakeListDTO = ArticleListDTO(
            count: 1,
            next: next,
            previous: nil,
            results: [fakeDetailDTO]
        )
        return ArticleResponseModel(dto: fakeListDTO)
    }

    // MARK: - initialLoad

    func test_GivenSuccessfulLoad_WhenInitialLoad_ThenStateIsData() async {
        // Arrange
        mockListUseCase.executeResult = .success(makeFakeResponse(title: "Initial Article"))

        let expectation = XCTestExpectation(description: "state cambia a .data")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .data(let articles, let isLoadingMore) = state {
                    XCTAssertEqual(articles.count, 1)
                    XCTAssertEqual(articles.first?.title, "Initial Article")
                    XCTAssertFalse(isLoadingMore)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.initialLoad()

        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        if case .data = viewModel.state { } else {
            XCTFail("Se esperaba state == .data, pero se obtuvo: \(viewModel.state)")
        }
    }

    func test_GivenNetworkError_WhenInitialLoad_ThenStateIsError() async {
        // Arrange
        mockListUseCase.executeResult = .failure(ServiceError.conexionError)

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
        viewModel.initialLoad()

        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        if case .error = viewModel.state { } else {
            XCTFail("Se esperaba state == .error, pero se obtuvo: \(viewModel.state)")
        }
    }

    func test_GivenEmptyResults_WhenInitialLoad_ThenStateIsEmpty() async {
        // Arrange
        let emptyListDTO = ArticleListDTO(count: 0, next: nil, previous: nil, results: [])
        let emptyResponse = ArticleResponseModel(dto: emptyListDTO)
        mockListUseCase.executeResult = .success(emptyResponse)

        let expectation = XCTestExpectation(description: "state cambia a .empty")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.initialLoad()

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_GivenIdleState_WhenInitialLoadCalledTwice_ThenFetchOnlyOnce() async {
        // Arrange
        mockListUseCase.executeResult = .success(makeFakeResponse(title: "Article"))

        let expectation = XCTestExpectation(description: "state cambia a .data")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .data = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.initialLoad()a

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(mockListUseCase.executeCallCount, 1)
    }

    // MARK: - Search

    func test_GivenSearchText_WhenDebounceTriggers_ThenSearchUseCaseIsCalled() async {
        // Arrange
        mockSearchUseCase.executeResult = .success(makeFakeResponse(id: 2, title: "Search Result"))

        let expectation = XCTestExpectation(description: "state cambia a .data con resultados de búsqueda")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .data(let articles, let isLoadingMore) = state {
                    XCTAssertEqual(articles.count, 1)
                    XCTAssertEqual(articles.first?.title, "Search Result")
                    XCTAssertFalse(isLoadingMore)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.searchText = "SpaceX"

        await fulfillment(of: [expectation], timeout: 1.5)

        // Assert 
        XCTAssertEqual(mockSearchUseCase.executeCallCount, 1)
        XCTAssertEqual(mockListUseCase.executeCallCount, 0)
    }

    func test_GivenSearchError_WhenDebounceTriggers_ThenStateIsError() async {
        // Arrange
        mockSearchUseCase.executeResult = .failure(ServiceError.conexionError)

        let expectation = XCTestExpectation(description: "state cambia a .error tras fallo en búsqueda")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Act
        viewModel.searchText = "SpaceX"

        await fulfillment(of: [expectation], timeout: 1.5)
    }
}
