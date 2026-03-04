//
//  SplashViewController.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import UIKit
import Lottie

final class SplashViewController: UIViewController {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "RocketLaunch")
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onFinished: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play { [weak self] _ in
            self?.onFinished?()
        }
    }
    
    private func setupLayout() {
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
