//
//  ArticleDetailViewModel.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//  

import Foundation

@MainActor
final class ArticleDetailViewModel: ArticleDetailViewModelProtocol {
    
    @Published private(set) var state: ArticleDetailState = .idle
    
    private let useCase: ArticleDetailUseCaseProtocol
    private let articleId: Int
    
    var article: ArticleModel?
    private var loadTask: Task<Void, Never>?
    
    init(
        articleId: Int,
        useCase: ArticleDetailUseCaseProtocol = ArticleDetailUseCase()
    ) {
        self.articleId = articleId
        self.useCase = useCase
    }
    
    var site: String {
        article?.newsSite.uppercased() ?? ""
    }
    
    var title: String {
        article?.title ?? ""
    }
    
    var authors: [String] {
        article?.authors ?? []
    }
    
    var publishedDate: String? {
        article?.publishedAt?
            .formatted(date: .long, time: .omitted)
    }
    
    var imageURL: String? {
        guard let url = article?.imageUrl else { return nil }
        return url
    }
    
    var summary: String {
        article?.summary ?? ""
    }
    
    var articleURL: URL? {
        guard let url = article?.url else { return nil }
        return URL(string: url)
    }
    
    func loadArticleDetail() {
        if case .loading = state { return }

        loadTask?.cancel()

        state = .loading

        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await self.useCase.execute(id: self.articleId)
                self.article = result
                self.state = .loaded
            } catch let serviceError as ServiceError {
                state = .error(serviceError)
                
            } catch {
                state = .error(.conexionError)
            }
        }
    }

    deinit {
        loadTask?.cancel()
    }
}
