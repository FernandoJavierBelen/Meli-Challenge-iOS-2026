//
//  ArticleDetailDTO.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

struct ArticleDetailDTO: Codable {
    let id: Int
    let title: String
    let authors: [AuthorDTO]?
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
    let updatedAt: String
    let featured: Bool
    let events: [EventDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, authors, url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case featured
        case events
    }
}
