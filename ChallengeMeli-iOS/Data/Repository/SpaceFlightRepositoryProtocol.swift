//
//  SpaceFlightRepositoryProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

protocol SpaceFlightRepositoryProtocol {
    func listArticles(limit: Int?, offset: Int?) async throws -> ArticleListDTO
    
    func searchArticles(query: String, limit: Int?, offset: Int?) async throws -> ArticleListDTO
    
    func getArticleDetail(id: Int) async throws -> ArticleDetailDTO
}
