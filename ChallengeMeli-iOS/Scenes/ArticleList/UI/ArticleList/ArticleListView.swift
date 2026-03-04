//
//  ArticleListView.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 01/03/2026
//

import SwiftUI

struct ArticleListView<ViewModel: ArticleListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                searchBar
                content
            }
            .padding(.top, 16)
            .background(Color(.systemGroupedBackground))
            .onAppear {
                viewModel.initialLoad()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $viewModel.searchText)
                .focused($isFocused)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
                .shadow(radius: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? .black : .clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle, .loading:
            ProgressView()
                .tint(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let serviceError):
            FeedbackView.forServiceError(serviceError)

        case .empty(let query):
            FeedbackView.forEmpty(query: query)

        case .data(let articles, let isLoadingMore):
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    
                    ForEach(articles) { article in
                        NavigationLink {
                            ArticleDetailView(
                                viewModel: ArticleDetailViewModel(articleId: article.id)
                            )
                        } label: {
                            ArticleListRow(
                                viewModel: ArticleListRowViewModel(article: article)
                            )
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white)
                                    .shadow(radius: 2)
                            )
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: article)
                        }
                    }
                    
                    if isLoadingMore {
                        ProgressView()
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}

#Preview {
    ArticleListView(viewModel: ArticleListViewModel())
}
