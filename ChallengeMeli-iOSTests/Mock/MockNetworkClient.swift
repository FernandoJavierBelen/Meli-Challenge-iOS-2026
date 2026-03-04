////
//  MockNetworkClient.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import Foundation
@testable import ChallengeMeli_iOS

class MockNetworkClient: NetworkClientProtocol {
    var requestResult: Any?
    var requestError: Error?
    private(set) var requestCallCount = 0
    private(set) var lastEndpoint: (any Endpoint)?

    func request<T: Decodable>(endpoint: any Endpoint) async throws -> T {
        requestCallCount += 1
        lastEndpoint = endpoint

        if let error = requestError {
            throw error
        }

        if let result = requestResult as? T {
            return result
        }

        throw ServiceError.conexionError
    }
}
