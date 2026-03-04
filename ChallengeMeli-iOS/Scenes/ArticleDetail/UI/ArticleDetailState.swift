//
//  ArticleDetailState.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import Foundation

enum ArticleDetailState {
    case idle
    case loading
    case error(ServiceError)
    case loaded
}
