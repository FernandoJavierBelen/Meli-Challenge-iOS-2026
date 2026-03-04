//
//  SectionView.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 5) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 8) {
                        Text(item)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
