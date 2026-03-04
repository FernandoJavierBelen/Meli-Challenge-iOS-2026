//
//  ArticleDetailUseCase.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

protocol ArticleDetailUseCaseProtocol {
    func execute(id: Int) async throws -> ArticleModel
}

class ArticleDetailUseCase: ArticleDetailUseCaseProtocol {
    private let repository: SpaceFlightRepositoryProtocol
    
    init(repository: SpaceFlightRepositoryProtocol = SpaceFlightRepository()) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> ArticleModel {
        let detailDTO = try await repository.getArticleDetail(id: id)
        
        return ArticleModel(
            id: detailDTO.id,
            title: detailDTO.title,
            imageUrl: detailDTO.imageUrl,
            newsSite: detailDTO.newsSite,
            summary: detailDTO.summary,
            url: detailDTO.url,
            publishedAt: detailDTO.publishedAt.toSpaceFlightDate(),
            authors: detailDTO.authors?.map { $0.name } ?? []
        )
    }
}
