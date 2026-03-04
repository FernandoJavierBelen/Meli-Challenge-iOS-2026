//
//  ArticleListRowViewModel.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import Foundation

final class ArticleListRowViewModel: ArticleListRowViewModelProtocol {
    
    private let article: ArticleModel
    
    init(article: ArticleModel) {
        self.article = article
    }
    
    var id: Int {
        article.id
    }
    
    var title: String {
        article.title
    }
    
    var site: String {
        article.newsSite
    }
    
    var summary: String {
        article.summary
    }
    
    var imageURL: String? {
        article.imageUrl
    }
}
