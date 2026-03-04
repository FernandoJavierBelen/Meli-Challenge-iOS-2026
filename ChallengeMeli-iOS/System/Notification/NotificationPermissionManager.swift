////
//  NotificationPermissionManager.swift
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 02/03/2026.
//  
//

import UIKit
import UserNotifications

protocol NotificationPermissionProtocol {
    func requestPermissionIfNeeded()
}

final class NotificationPermissionManager: NotificationPermissionProtocol {
    
    private let center: UNUserNotificationCenter
    
    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }
    
    func requestPermissionIfNeeded() {
        center.getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            
            self?.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
}
