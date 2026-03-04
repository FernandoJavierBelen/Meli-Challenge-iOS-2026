//
//  MockUseCases.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import Foundation
@testable import ChallengeMeli_iOS

class MockListArticlesUseCase: ListArticlesUseCaseProtocol {
    var executeResult: Result<ArticleResponseModel, Error>?
    private(set) var executeCallCount = 0

    func execute(limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        executeCallCount += 1
        if let result = executeResult {
            return try result.get()
        }
        throw ServiceError.conexionError
    }
}

class MockSearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    var executeResult: Result<ArticleResponseModel, Error>?
    private(set) var executeCallCount = 0

    func execute(query: String, limit: Int?, offset: Int?) async throws -> ArticleResponseModel {
        executeCallCount += 1
        if let result = executeResult {
            return try result.get()
        }
        throw ServiceError.conexionError
    }
}

class MockArticleDetailUseCase: ArticleDetailUseCaseProtocol {
    var executeResult: Result<ArticleModel, Error>?
    private(set) var executeCallCount = 0

    func execute(id: Int) async throws -> ArticleModel {
        executeCallCount += 1
        if let result = executeResult {
            return try result.get()
        }
        throw ServiceError.conexionError
    }
}
