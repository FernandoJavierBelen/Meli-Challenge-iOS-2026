//
//  ArticleListRowViewModelProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import Foundation

protocol ArticleListRowViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var site: String { get }
    var summary: String { get }
    var imageURL: String? { get }
}
