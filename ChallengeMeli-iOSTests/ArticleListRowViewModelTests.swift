////
//  ArticleListRowViewModelTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class ArticleListRowViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeFakeArticle(
        id: Int = 1,
        title: String = "Test Title",
        imageUrl: String = "https://image.com/test.jpg",
        newsSite: String = "Space News",
        summary: String = "Test Summary",
        url: String = "https://test.com/article"
    ) -> ArticleModel {
        ArticleModel(
            id: id,
            title: title,
            imageUrl: imageUrl,
            newsSite: newsSite,
            summary: summary,
            url: url,
            publishedAt: Date(),
            authors: ["Author One"]
        )
    }

    // MARK: - id

    func test_GivenArticle_WhenAccessingId_ThenReturnsArticleId() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(id: 42))
        XCTAssertEqual(viewModel.id, 42)
    }

    // MARK: - title

    func test_GivenArticle_WhenAccessingTitle_ThenReturnsArticleTitle() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(title: "SpaceX Launch"))
        XCTAssertEqual(viewModel.title, "SpaceX Launch")
    }

    // MARK: - site

    func test_GivenArticle_WhenAccessingSite_ThenReturnsNewsSite() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(newsSite: "NASA"))
        XCTAssertEqual(viewModel.site, "NASA")
    }

    // MARK: - summary

    func test_GivenArticle_WhenAccessingSummary_ThenReturnsArticleSummary() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(summary: "A long summary"))
        XCTAssertEqual(viewModel.summary, "A long summary")
    }

    // MARK: - imageURL

    func test_GivenArticle_WhenAccessingImageURL_ThenReturnsImageUrl() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(imageUrl: "https://img.com/photo.jpg"))
        XCTAssertEqual(viewModel.imageURL, "https://img.com/photo.jpg")
    }

    func test_GivenArticleWithEmptyImageUrl_WhenAccessingImageURL_ThenReturnsEmptyString() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle(imageUrl: ""))
        XCTAssertEqual(viewModel.imageURL, "")
    }

    // MARK: - Protocol conformance

    func test_GivenArticleListRowViewModel_WhenCreated_ThenConformsToProtocol() {
        let viewModel = ArticleListRowViewModel(article: makeFakeArticle())
        let _: ArticleListRowViewModelProtocol = viewModel
        XCTAssertNotNil(viewModel)
    }

    // MARK: - All fields together

    func test_GivenArticle_WhenAccessingAllProperties_ThenAllMatchArticleFields() {
        let article = makeFakeArticle(
            id: 99,
            title: "Mars Mission",
            imageUrl: "https://mars.com/img.jpg",
            newsSite: "Mars Daily",
            summary: "Mission to Mars",
            url: "https://mars.com/article"
        )
        let viewModel = ArticleListRowViewModel(article: article)

        XCTAssertEqual(viewModel.id, 99)
        XCTAssertEqual(viewModel.title, "Mars Mission")
        XCTAssertEqual(viewModel.site, "Mars Daily")
        XCTAssertEqual(viewModel.summary, "Mission to Mars")
        XCTAssertEqual(viewModel.imageURL, "https://mars.com/img.jpg")
    }
}
