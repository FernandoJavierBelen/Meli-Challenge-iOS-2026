//
//  ArticleResponseModel.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 28/02/2026.
// 

struct ArticleResponseModel {
    let count: Int
    let next: String?
    let previous: String?
    let articles: [ArticleModel]

    init(dto: ArticleListDTO) {
        self.count = dto.count
        self.next = dto.next
        self.previous = dto.previous

        self.articles = dto.results.map { detailDTO in
            ArticleModel(
                id: detailDTO.id,
                title: detailDTO.title,
                imageUrl: detailDTO.imageUrl,
                newsSite: detailDTO.newsSite,
                summary: detailDTO.summary,
                url: detailDTO.url,
                publishedAt: detailDTO.publishedAt.toSpaceFlightDate(),
                authors: detailDTO.authors?.map { $0.name } ?? []
            )
        }
    }
}
