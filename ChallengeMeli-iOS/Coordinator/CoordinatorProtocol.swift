//
//  CoordinatorProtocol.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
