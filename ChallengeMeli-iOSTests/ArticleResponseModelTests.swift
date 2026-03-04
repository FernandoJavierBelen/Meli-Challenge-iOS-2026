////
//  ArticleResponseModelTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class ArticleResponseModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeDetailDTO(
        id: Int = 1,
        title: String = "Test",
        authors: [AuthorDTO]? = nil,
        publishedAt: String = "2025-10-30T14:00:00Z"
    ) -> ArticleDetailDTO {
        ArticleDetailDTO(
            id: id, title: title, authors: authors, url: "https://test.com",
            imageUrl: "https://img.com", newsSite: "Site", summary: "Summary",
            publishedAt: publishedAt, updatedAt: "2025-10-30T14:00:00Z",
            featured: false, events: nil
        )
    }

    // MARK: - Mapping from DTO

    func test_GivenSingleArticleDTO_WhenMapped_ThenArticlesCountIsOne() {
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [makeDetailDTO()])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertEqual(model.articles.count, 1)
        XCTAssertEqual(model.count, 1)
    }

    func test_GivenMultipleArticleDTOs_WhenMapped_ThenAllArticlesAreMapped() {
        let dtos = [
            makeDetailDTO(id: 1, title: "Article 1"),
            makeDetailDTO(id: 2, title: "Article 2"),
            makeDetailDTO(id: 3, title: "Article 3")
        ]
        let listDTO = ArticleListDTO(count: 3, next: "next", previous: "prev", results: dtos)
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertEqual(model.articles.count, 3)
        XCTAssertEqual(model.articles[0].title, "Article 1")
        XCTAssertEqual(model.articles[1].title, "Article 2")
        XCTAssertEqual(model.articles[2].title, "Article 3")
        XCTAssertEqual(model.next, "next")
        XCTAssertEqual(model.previous, "prev")
    }

    func test_GivenEmptyResults_WhenMapped_ThenArticlesIsEmpty() {
        let listDTO = ArticleListDTO(count: 0, next: nil, previous: nil, results: [])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertTrue(model.articles.isEmpty)
        XCTAssertEqual(model.count, 0)
        XCTAssertNil(model.next)
        XCTAssertNil(model.previous)
    }

    // MARK: - Authors mapping

    func test_GivenDTOWithAuthors_WhenMapped_ThenAuthorsNamesAreMapped() {
        let authors = [AuthorDTO(name: "Alice"), AuthorDTO(name: "Bob")]
        let dto = makeDetailDTO(authors: authors)
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertEqual(model.articles.first?.authors, ["Alice", "Bob"])
    }

    func test_GivenDTOWithNilAuthors_WhenMapped_ThenAuthorsIsEmptyArray() {
        let dto = makeDetailDTO(authors: nil)
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertEqual(model.articles.first?.authors, [])
    }

    func test_GivenDTOWithEmptyAuthors_WhenMapped_ThenAuthorsIsEmptyArray() {
        let dto = makeDetailDTO(authors: [])
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertEqual(model.articles.first?.authors, [])
    }

    // MARK: - Date mapping

    func test_GivenValidPublishedAt_WhenMapped_ThenDateIsNotNil() {
        let dto = makeDetailDTO(publishedAt: "2025-10-30T14:00:00Z")
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertNotNil(model.articles.first?.publishedAt)
    }

    func test_GivenInvalidPublishedAt_WhenMapped_ThenDateIsNil() {
        let dto = makeDetailDTO(publishedAt: "invalid-date")
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertNil(model.articles.first?.publishedAt)
    }

    func test_GivenEmptyPublishedAt_WhenMapped_ThenDateIsNil() {
        let dto = makeDetailDTO(publishedAt: "")
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)

        XCTAssertNil(model.articles.first?.publishedAt)
    }

    // MARK: - Field mapping

    func test_GivenDTO_WhenMapped_ThenAllFieldsAreMappedCorrectly() {
        let dto = ArticleDetailDTO(
            id: 55,
            title: "Full Article",
            authors: [AuthorDTO(name: "Author")],
            url: "https://full.com/article",
            imageUrl: "https://full.com/image.jpg",
            newsSite: "Full Site",
            summary: "Full summary text",
            publishedAt: "2025-06-15T10:30:00Z",
            updatedAt: "2025-06-16T10:30:00Z",
            featured: true,
            events: [EventDTO(eventId: 1, provider: "Provider")]
        )
        let listDTO = ArticleListDTO(count: 1, next: nil, previous: nil, results: [dto])
        let model = ArticleResponseModel(dto: listDTO)
        let article = model.articles.first!

        XCTAssertEqual(article.id, 55)
        XCTAssertEqual(article.title, "Full Article")
        XCTAssertEqual(article.url, "https://full.com/article")
        XCTAssertEqual(article.imageUrl, "https://full.com/image.jpg")
        XCTAssertEqual(article.newsSite, "Full Site")
        XCTAssertEqual(article.summary, "Full summary text")
        XCTAssertEqual(article.authors, ["Author"])
        XCTAssertNotNil(article.publishedAt)
    }
}
