////
//  ArticleModelIdentifiableTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class ArticleModelIdentifiableTests: XCTestCase {

    // MARK: - Helpers

    private func makeArticle(
        id: Int = 1,
        title: String = "Test",
        imageUrl: String = "img",
        newsSite: String = "Site",
        summary: String = "Summary",
        url: String = "url",
        publishedAt: Date? = nil,
        authors: [String] = []
    ) -> ArticleModel {
        ArticleModel(
            id: id, title: title, imageUrl: imageUrl, newsSite: newsSite,
            summary: summary, url: url, publishedAt: publishedAt, authors: authors
        )
    }

    // MARK: - Identifiable

    func test_GivenArticleModel_WhenAccessingId_ThenReturnsCorrectId() {
        let article = makeArticle(id: 42)
        XCTAssertEqual(article.id, 42)
    }

    // MARK: - Hashable

    func test_GivenTwoEqualArticles_WhenComparedForEquality_ThenAreEqual() {
        let date = Date()
        let article1 = makeArticle(id: 1, title: "Same", publishedAt: date, authors: ["A"])
        let article2 = makeArticle(id: 1, title: "Same", publishedAt: date, authors: ["A"])
        XCTAssertEqual(article1, article2)
    }

    func test_GivenTwoDifferentArticles_WhenComparedForEquality_ThenAreNotEqual() {
        let article1 = makeArticle(id: 1, title: "Title 1")
        let article2 = makeArticle(id: 2, title: "Title 2")
        XCTAssertNotEqual(article1, article2)
    }

    func test_GivenArticleModel_WhenUsedInSet_ThenHashableWorks() {
        let article1 = makeArticle(id: 1, title: "A")
        let article2 = makeArticle(id: 2, title: "B")
        let article3 = makeArticle(id: 1, title: "A")

        var set: Set<ArticleModel> = []
        set.insert(article1)
        set.insert(article2)
        set.insert(article3)

        XCTAssertEqual(set.count, 2)
    }

    // MARK: - All fields

    func test_GivenArticle_WhenAccessingAllFields_ThenAllFieldsAreCorrect() {
        let date = Date()
        let article = makeArticle(
            id: 99,
            title: "Mars",
            imageUrl: "https://img.com/mars.jpg",
            newsSite: "Mars News",
            summary: "Summary about Mars",
            url: "https://mars.com",
            publishedAt: date,
            authors: ["Alice", "Bob"]
        )

        XCTAssertEqual(article.id, 99)
        XCTAssertEqual(article.title, "Mars")
        XCTAssertEqual(article.imageUrl, "https://img.com/mars.jpg")
        XCTAssertEqual(article.newsSite, "Mars News")
        XCTAssertEqual(article.summary, "Summary about Mars")
        XCTAssertEqual(article.url, "https://mars.com")
        XCTAssertEqual(article.publishedAt, date)
        XCTAssertEqual(article.authors, ["Alice", "Bob"])
    }

    func test_GivenArticleWithNilDate_WhenAccessingPublishedAt_ThenIsNil() {
        let article = makeArticle(publishedAt: nil)
        XCTAssertNil(article.publishedAt)
    }

    func test_GivenArticleWithEmptyAuthors_WhenAccessingAuthors_ThenIsEmptyArray() {
        let article = makeArticle(authors: [])
        XCTAssertTrue(article.authors.isEmpty)
    }
}
