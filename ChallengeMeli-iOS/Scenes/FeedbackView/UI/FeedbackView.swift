//
//  FeedbackView.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import SwiftUI

struct FeedbackView: View {

    let imageName: String?
    let title: String
    let description: String

    init(
        imageName: String?,
        title: String,
        description: String
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
    }

    var body: some View {
        VStack {
            Spacer(minLength: 0)

            content

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 16) {

            if let imageName, !imageName.isEmpty {
                imageView(name: imageName)
            }

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Text(description)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func imageView(name: String) -> some View {
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(height: 130)
        } else {
            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(.secondary)
        }
    }
}

extension FeedbackView {

    static func forServiceError(_ error: ServiceError?) -> FeedbackView {
        switch error {
        case .conexionError:
            return FeedbackView(
                imageName: "wifi.slash",
                title: "Sin conexión",
                description: "Revisa tu conexión a Internet e intenta nuevamente."
            )

        case .notFountError:
            return FeedbackView(
                imageName: "magnifyingglass",
                title: "No encontrado",
                description: "No se encontró el recurso solicitado."
            )

        case .none:
            return FeedbackView(
                imageName: "exclamationmark.triangle",
                title: "Error",
                description: "Ocurrió un error inesperado."
            )
        }
    }

    static func forEmpty(query: String) -> FeedbackView {
        FeedbackView(
            imageName: "magnifyingglass",
            title: "No se encontraron resultados",
            description: "De \"\(query)\"."
        )
    }
}

#Preview {
    Group {
        FeedbackView.forServiceError(.conexionError)
        FeedbackView.forEmpty(query: "")
    }
}
