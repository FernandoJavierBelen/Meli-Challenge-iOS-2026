//
//  ListArticlesUseCase.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//  

import Foundation

protocol ListArticlesUseCaseProtocol {
    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel
}

class ListArticlesUseCase: ListArticlesUseCaseProtocol {
    private let repository: SpaceFlightRepositoryProtocol
    
    init(repository: SpaceFlightRepositoryProtocol = SpaceFlightRepository()) {
        self.repository = repository
    }
    
    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        let listDTO = try await repository.listArticles(limit: limit, offset: offset)
        
        return ArticleResponseModel(dto: listDTO)
    }
}
