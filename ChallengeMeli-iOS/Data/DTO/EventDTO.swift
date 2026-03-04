//
//  EventDTO.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
//

import Foundation

struct EventDTO: Codable {
    let eventId: Int
    let provider: String

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case provider
    }
}
