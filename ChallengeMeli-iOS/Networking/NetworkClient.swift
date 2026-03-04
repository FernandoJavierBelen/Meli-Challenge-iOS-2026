//
//  NetworkClient.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {

        guard let url = endpoint.url else {
            throw ServiceError.notFountError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.conexionError
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ServiceError(httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch let urlError as URLError {
            
            if urlError.code == .notConnectedToInternet {
                throw ServiceError.conexionError
            }
            
            throw ServiceError.conexionError
            
        } catch {
            throw ServiceError.conexionError
        }
    }
}
