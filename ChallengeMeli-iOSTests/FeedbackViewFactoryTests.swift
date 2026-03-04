////
//  FeedbackViewFactoryTests.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 04/03/2026.
//

import XCTest
@testable import ChallengeMeli_iOS

class FeedbackViewFactoryTests: XCTestCase {

    // MARK: - forServiceError

    func test_GivenConexionError_WhenCreatingFeedbackView_ThenReturnsCorrectProperties() {
        let view = FeedbackView.forServiceError(.conexionError)

        XCTAssertEqual(view.imageName, "wifi.slash")
        XCTAssertEqual(view.title, "Sin conexión")
        XCTAssertEqual(view.description, "Revisa tu conexión a Internet e intenta nuevamente.")
    }

    func test_GivenNotFountError_WhenCreatingFeedbackView_ThenReturnsCorrectProperties() {
        let view = FeedbackView.forServiceError(.notFountError)

        XCTAssertEqual(view.imageName, "magnifyingglass")
        XCTAssertEqual(view.title, "No encontrado")
        XCTAssertEqual(view.description, "No se encontró el recurso solicitado.")
    }

    func test_GivenNilError_WhenCreatingFeedbackView_ThenReturnsGenericError() {
        let view = FeedbackView.forServiceError(nil)

        XCTAssertEqual(view.imageName, "exclamationmark.triangle")
        XCTAssertEqual(view.title, "Error")
        XCTAssertEqual(view.description, "Ocurrió un error inesperado.")
    }

    // MARK: - forEmpty

    func test_GivenQuery_WhenCreatingEmptyFeedbackView_ThenReturnsCorrectProperties() {
        let view = FeedbackView.forEmpty(query: "SpaceX")

        XCTAssertEqual(view.imageName, "magnifyingglass")
        XCTAssertEqual(view.title, "No se encontraron resultados")
        XCTAssertEqual(view.description, "De \"SpaceX\".")
    }

    func test_GivenEmptyQuery_WhenCreatingEmptyFeedbackView_ThenReturnsCorrectDescription() {
        let view = FeedbackView.forEmpty(query: "")

        XCTAssertEqual(view.title, "No se encontraron resultados")
        XCTAssertEqual(view.description, "De \"\".")
    }

    // MARK: - Init

    func test_GivenCustomValues_WhenCreatingFeedbackView_ThenPropertiesAreSet() {
        let view = FeedbackView(
            imageName: "star",
            title: "Custom Title",
            description: "Custom Description"
        )

        XCTAssertEqual(view.imageName, "star")
        XCTAssertEqual(view.title, "Custom Title")
        XCTAssertEqual(view.description, "Custom Description")
    }

    func test_GivenNilImageName_WhenCreatingFeedbackView_ThenImageNameIsNil() {
        let view = FeedbackView(
            imageName: nil,
            title: "No Image",
            description: "Description"
        )

        XCTAssertNil(view.imageName)
        XCTAssertEqual(view.title, "No Image")
    }
}
