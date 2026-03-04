////
//  MockSpaceFlightRepository.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//  
//

import Foundation
@testable import ChallengeMeli_iOS

class MockSpaceFlightRepository: SpaceFlightRepositoryProtocol {
    var listArticlesResult: Result<ArticleListDTO, Error>?
    var searchArticlesResult: Result<ArticleListDTO, Error>?
    var getArticleDetailResult: Result<ArticleDetailDTO, Error>?

    func listArticles(limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        if let result = listArticlesResult {
            switch result {
            case .success(let dto):
                return dto
            case .failure(let error):
                throw error
            }
        }
        throw ServiceError.conexionError
    }
    
    func searchArticles(query: String, limit: Int?, offset: Int?) async throws -> ArticleListDTO {
        if let result = searchArticlesResult {
            return try result.get()
        }
        throw ServiceError.conexionError
    }
    
    func getArticleDetail(id: Int) async throws -> ArticleDetailDTO {
        if let result = getArticleDetailResult {
            return try result.get()
        }
        throw ServiceError.conexionError
    }
}
