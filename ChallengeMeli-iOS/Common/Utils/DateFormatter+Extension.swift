//
//  DateFormatter+Extension.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import Foundation

extension ISO8601DateFormatter {
    static let spaceFlightFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        return formatter
    }()
}

extension String {
    func toSpaceFlightDate() -> Date? {
        return ISO8601DateFormatter.spaceFlightFormatter.date(from: self)
    }
}
