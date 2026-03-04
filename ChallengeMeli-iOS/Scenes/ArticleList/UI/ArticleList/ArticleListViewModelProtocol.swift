//
//  ArticleListViewModelProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import Foundation

@MainActor
protocol ArticleListViewModelProtocol: ObservableObject {
    var state: ArticleListState { get }
    var searchText: String { get set }
    func fetch(reset: Bool)
    func initialLoad()
    func loadMoreIfNeeded(currentItem: ArticleModel)
}
