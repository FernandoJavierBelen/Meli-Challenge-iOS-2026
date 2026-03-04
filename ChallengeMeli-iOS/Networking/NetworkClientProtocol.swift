//
//  NetworkClientProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

enum ServiceError: Error {
    case notFountError
    case conexionError

    init(_ response: Int?) {
        guard let response = response else {
            self = .conexionError
            return
        }

        switch response {
        case 400...502:
            self = .notFountError
        default:
            self = .conexionError
        }
    }
}
