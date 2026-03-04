//
//  SearchArticlesUseCase.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

protocol SearchArticlesUseCaseProtocol {
    func execute(query: String, limit: Int?, offset: Int?) async throws -> ArticleResponseModel
}

class SearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    private let repository: SpaceFlightRepositoryProtocol
    
    init(repository: SpaceFlightRepositoryProtocol = SpaceFlightRepository()) {
        self.repository = repository
    }
    
    func execute(query: String, limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        let listDTO = try await repository.searchArticles(query: query, limit: limit, offset: offset)
        
        return ArticleResponseModel(dto: listDTO)
    }
}
