//
//  RemoteImageView.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

import SwiftUI

struct RemoteImageView: View {
    
    let urlString: String
    let contentMode: ContentMode
    let placeholder: Image
    
    init(
        urlString: String,
        contentMode: ContentMode = .fit,
        placeholder: Image = Image(systemName: "photo")
    ) {
        self.urlString = urlString
        self.contentMode = contentMode
        self.placeholder = placeholder
    }
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                imageView(image)
            case .empty, .failure:
                imageView(placeholder)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func imageView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
