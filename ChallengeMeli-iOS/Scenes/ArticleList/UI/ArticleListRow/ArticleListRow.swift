//
//  ArticleListRow.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import SwiftUI

struct ArticleListRow<ViewModel: ArticleListRowViewModelProtocol>: View {
    
    let viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            
            RemoteImageView(urlString: viewModel.imageURL ?? "")
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(viewModel.site)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.black)
                    .clipShape(Capsule())
                
                Text(viewModel.title)
                    .font(.headline)
                    .lineLimit(2)
                    
                Text(viewModel.summary)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
