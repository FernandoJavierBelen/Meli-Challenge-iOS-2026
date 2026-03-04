//
//  ArticleDTO.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

struct ArticleListDTO: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ArticleDetailDTO]
}
