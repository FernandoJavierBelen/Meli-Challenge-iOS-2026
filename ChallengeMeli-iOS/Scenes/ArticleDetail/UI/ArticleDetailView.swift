//
//  ArticleDetailView.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import SwiftUI

struct ArticleDetailView<ViewModel: ArticleDetailViewModelProtocol>: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                loadingView
                
            case .error(let serviceError):
                FeedbackView.forServiceError(serviceError)
                
            case .loaded:
                scrollContent
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.loadArticleDetail()
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .tint(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                closeButton
                articleContent
            }
        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(12)
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    private var articleContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(viewModel.site)
                .font(.caption.weight(.bold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
            
            Text(viewModel.title)
                .font(.title3.bold())
                .padding(.horizontal, 15)
            
            HStack {
                if !viewModel.authors.isEmpty {
                    SectionView(title: "written by", items: viewModel.authors)
                }
                Spacer()
                
                if let date = viewModel.publishedDate {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(15)
            
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 250)
                .overlay(
                    RemoteImageView(urlString: viewModel.imageURL ?? "")
                        .scaledToFill()
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 40) {
                Text(viewModel.summary)
                    .font(.body)
                
                if let url = viewModel.articleURL {
                    Link(destination: url) {
                        Text("Read the full article on \(viewModel.site)")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .underline()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(
            viewModel: ArticleDetailViewModel(articleId: 31598)
        )
    }
}
