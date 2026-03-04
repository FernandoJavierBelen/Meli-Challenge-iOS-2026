//
//  ArticleListState.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import Foundation

enum ArticleListState {
    case idle
    case loading
    case error(ServiceError)
    case empty(String)
    case data([ArticleModel], isLoadingMore: Bool)
}
