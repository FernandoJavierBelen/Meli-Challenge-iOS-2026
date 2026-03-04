//
//  ArticleModel.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
// 

import Foundation

struct ArticleModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let url: String
    let publishedAt: Date?
    let authors: [String]
}
