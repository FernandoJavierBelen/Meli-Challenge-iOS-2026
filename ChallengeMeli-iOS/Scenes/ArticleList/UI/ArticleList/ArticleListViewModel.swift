//
//  ArticleListViewModel.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import Foundation
import Combine

@MainActor
final class ArticleListViewModel: ArticleListViewModelProtocol {
    
    @Published private(set) var state: ArticleListState = .idle
    @Published var searchText: String = ""
    
    private let listUseCase: ListArticlesUseCaseProtocol
    private let searchUseCase: SearchArticlesUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true
    private var currentArticles: [ArticleModel] = []
    
    init(
        listUseCase: ListArticlesUseCaseProtocol = ListArticlesUseCase(),
        searchUseCase: SearchArticlesUseCaseProtocol = SearchArticlesUseCase()
    ) {
        self.listUseCase = listUseCase
        self.searchUseCase = searchUseCase
        bindSearch()
    }
    
    func initialLoad() {
        guard case .idle = state else { return }
        fetch(reset: true)
    }
    
    func loadMoreIfNeeded(currentItem: ArticleModel) {
        guard case .data(let articles, false) = state,
              canLoadMore,
              let index = articles.firstIndex(where: { $0.id == currentItem.id }),
              index >= articles.count - 5 else { return }
        
        fetch(reset: false)
    }
    
    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.fetch(reset: true)
            }
            .store(in: &cancellables)
    }
    
    func fetch(reset: Bool) {
        if reset {
            offset = 0
            canLoadMore = true
            currentArticles = []
            state = .loading
        } else {
            state = .data(currentArticles, isLoadingMore: true)
        }
        
        Task {
            do {
                let response: ArticleResponseModel
                
                if searchText.isEmpty {
                    response = try await listUseCase.execute(limit: limit, offset: offset)
                } else {
                    response = try await searchUseCase.execute(
                        query: searchText,
                        limit: limit,
                        offset: offset
                    )
                }
                
                currentArticles.append(contentsOf: response.articles)
                offset += response.articles.count
                canLoadMore = response.next != nil
                
                state = currentArticles.isEmpty
                ? .empty(searchText)
                : .data(currentArticles, isLoadingMore: false)
                
            } catch let serviceError as ServiceError {
                state = .error(serviceError)
                
            } catch {
                state = .error(.conexionError)
            }
        }
    }
}
