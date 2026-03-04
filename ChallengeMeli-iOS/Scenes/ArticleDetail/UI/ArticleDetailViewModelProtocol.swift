//
//  ArticleDetailViewModelProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import Foundation

@MainActor
protocol ArticleDetailViewModelProtocol: ObservableObject {
    
    var state: ArticleDetailState { get }
    var site: String { get }
    var title: String { get }
    var authors: [String] { get }
    var publishedDate: String? { get }
    var imageURL: String? { get }
    var summary: String { get }
    var articleURL: URL? { get }
    func loadArticleDetail()
}
