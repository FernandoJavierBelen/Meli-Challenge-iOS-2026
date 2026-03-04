////
//  DTODecodingTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class DTODecodingTests: XCTestCase {

    // MARK: - ArticleDetailDTO

    func test_GivenValidJSON_WhenDecodingArticleDetailDTO_ThenAllFieldsAreMappedCorrectly() throws {
        let json = """
        {
            "id": 1,
            "title": "Test Article",
            "authors": [{"name": "Author One"}],
            "url": "https://test.com/article",
            "image_url": "https://test.com/image.jpg",
            "news_site": "Test News",
            "summary": "Test summary text",
            "published_at": "2025-10-30T14:00:00Z",
            "updated_at": "2025-10-31T10:00:00Z",
            "featured": true,
            "events": [{"event_id": 42, "provider": "Launch Library 2"}]
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ArticleDetailDTO.self, from: json)

        XCTAssertEqual(dto.id, 1)
        XCTAssertEqual(dto.title, "Test Article")
        XCTAssertEqual(dto.url, "https://test.com/article")
        XCTAssertEqual(dto.imageUrl, "https://test.com/image.jpg")
        XCTAssertEqual(dto.newsSite, "Test News")
        XCTAssertEqual(dto.summary, "Test summary text")
        XCTAssertEqual(dto.publishedAt, "2025-10-30T14:00:00Z")
        XCTAssertEqual(dto.updatedAt, "2025-10-31T10:00:00Z")
        XCTAssertTrue(dto.featured)
        XCTAssertEqual(dto.authors?.count, 1)
        XCTAssertEqual(dto.authors?.first?.name, "Author One")
        XCTAssertEqual(dto.events?.count, 1)
        XCTAssertEqual(dto.events?.first?.eventId, 42)
        XCTAssertEqual(dto.events?.first?.provider, "Launch Library 2")
    }

    func test_GivenJSONWithoutOptionalFields_WhenDecodingArticleDetailDTO_ThenOptionalFieldsAreNil() throws {
        let json = """
        {
            "id": 2,
            "title": "Minimal Article",
            "url": "https://test.com",
            "image_url": "https://test.com/img.jpg",
            "news_site": "Site",
            "summary": "Summary",
            "published_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-01T00:00:00Z",
            "featured": false
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ArticleDetailDTO.self, from: json)

        XCTAssertEqual(dto.id, 2)
        XCTAssertEqual(dto.title, "Minimal Article")
        XCTAssertNil(dto.authors)
        XCTAssertNil(dto.events)
        XCTAssertFalse(dto.featured)
    }

    func test_GivenArticleDetailDTO_WhenEncoding_ThenProducesValidJSON() throws {
        let dto = ArticleDetailDTO(
            id: 5,
            title: "Encode Test",
            authors: [AuthorDTO(name: "Author")],
            url: "https://url.com",
            imageUrl: "https://img.com",
            newsSite: "Site",
            summary: "Summary",
            publishedAt: "2025-06-01T00:00:00Z",
            updatedAt: "2025-06-02T00:00:00Z",
            featured: true,
            events: [EventDTO(eventId: 10, provider: "Provider")]
        )

        let data = try JSONEncoder().encode(dto)
        let decoded = try JSONDecoder().decode(ArticleDetailDTO.self, from: data)

        XCTAssertEqual(decoded.id, dto.id)
        XCTAssertEqual(decoded.title, dto.title)
        XCTAssertEqual(decoded.imageUrl, dto.imageUrl)
        XCTAssertEqual(decoded.newsSite, dto.newsSite)
        XCTAssertEqual(decoded.publishedAt, dto.publishedAt)
        XCTAssertEqual(decoded.updatedAt, dto.updatedAt)
        XCTAssertEqual(decoded.featured, dto.featured)
    }

    // MARK: - ArticleListDTO

    func test_GivenValidJSON_WhenDecodingArticleListDTO_ThenAllFieldsAreMappedCorrectly() throws {
        let json = """
        {
            "count": 100,
            "next": "https://api.test.com/v4/articles/?limit=10&offset=10",
            "previous": null,
            "results": [
                {
                    "id": 1,
                    "title": "Article 1",
                    "url": "https://test.com/1",
                    "image_url": "https://img.com/1.jpg",
                    "news_site": "Site1",
                    "summary": "Summary 1",
                    "published_at": "2025-10-30T00:00:00Z",
                    "updated_at": "2025-10-30T00:00:00Z",
                    "featured": false
                }
            ]
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ArticleListDTO.self, from: json)

        XCTAssertEqual(dto.count, 100)
        XCTAssertEqual(dto.next, "https://api.test.com/v4/articles/?limit=10&offset=10")
        XCTAssertNil(dto.previous)
        XCTAssertEqual(dto.results.count, 1)
        XCTAssertEqual(dto.results.first?.id, 1)
        XCTAssertEqual(dto.results.first?.title, "Article 1")
    }

    func test_GivenEmptyResults_WhenDecodingArticleListDTO_ThenResultsArrayIsEmpty() throws {
        let json = """
        {
            "count": 0,
            "next": null,
            "previous": null,
            "results": []
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ArticleListDTO.self, from: json)

        XCTAssertEqual(dto.count, 0)
        XCTAssertNil(dto.next)
        XCTAssertNil(dto.previous)
        XCTAssertTrue(dto.results.isEmpty)
    }

    func test_GivenArticleListDTO_WhenEncoding_ThenProducesValidJSON() throws {
        let detailDTO = ArticleDetailDTO(
            id: 1, title: "Test", authors: nil, url: "url",
            imageUrl: "img", newsSite: "Site", summary: "Sum",
            publishedAt: "2025-01-01T00:00:00Z", updatedAt: "2025-01-01T00:00:00Z",
            featured: false, events: nil
        )
        let listDTO = ArticleListDTO(count: 1, next: "next", previous: nil, results: [detailDTO])

        let data = try JSONEncoder().encode(listDTO)
        let decoded = try JSONDecoder().decode(ArticleListDTO.self, from: data)

        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded.next, "next")
        XCTAssertEqual(decoded.results.count, 1)
    }

    // MARK: - AuthorDTO

    func test_GivenValidJSON_WhenDecodingAuthorDTO_ThenNameIsMapped() throws {
        let json = """
        {"name": "John Doe"}
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(AuthorDTO.self, from: json)
        XCTAssertEqual(dto.name, "John Doe")
    }

    func test_GivenAuthorDTO_WhenEncoding_ThenRoundTripsCorrectly() throws {
        let dto = AuthorDTO(name: "Jane Smith")
        let data = try JSONEncoder().encode(dto)
        let decoded = try JSONDecoder().decode(AuthorDTO.self, from: data)
        XCTAssertEqual(decoded.name, "Jane Smith")
    }

    // MARK: - EventDTO

    func test_GivenValidJSON_WhenDecodingEventDTO_ThenFieldsAreMapped() throws {
        let json = """
        {"event_id": 100, "provider": "Launch Library 2"}
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(EventDTO.self, from: json)
        XCTAssertEqual(dto.eventId, 100)
        XCTAssertEqual(dto.provider, "Launch Library 2")
    }

    func test_GivenEventDTO_WhenEncoding_ThenRoundTripsCorrectly() throws {
        let dto = EventDTO(eventId: 55, provider: "SpaceX")
        let data = try JSONEncoder().encode(dto)
        let decoded = try JSONDecoder().decode(EventDTO.self, from: data)
        XCTAssertEqual(decoded.eventId, 55)
        XCTAssertEqual(decoded.provider, "SpaceX")
    }

    // MARK: - Multiple authors and events

    func test_GivenMultipleAuthors_WhenDecoding_ThenAllAuthorsAreMapped() throws {
        let json = """
        {
            "id": 3,
            "title": "Multi Author",
            "authors": [{"name": "Alice"}, {"name": "Bob"}, {"name": "Charlie"}],
            "url": "https://test.com",
            "image_url": "https://img.com",
            "news_site": "Site",
            "summary": "Summary",
            "published_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-01T00:00:00Z",
            "featured": false,
            "events": []
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ArticleDetailDTO.self, from: json)

        XCTAssertEqual(dto.authors?.count, 3)
        XCTAssertEqual(dto.authors?[0].name, "Alice")
        XCTAssertEqual(dto.authors?[1].name, "Bob")
        XCTAssertEqual(dto.authors?[2].name, "Charlie")
        XCTAssertEqual(dto.events?.count, 0)
    }
}
