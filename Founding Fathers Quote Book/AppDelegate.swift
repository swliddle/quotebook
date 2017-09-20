//
//  AppDelegate.swift
//  Founding Fathers Quote Book
//
//  Created by Steve Liddle on 9/13/17.
//  Copyright © 2017 Steve Liddle. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - Application lifecycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                                                [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { _,_ in }
        
        return true
    }

    // MARK: - User notification center delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        segueToQuoteOfTheDay()
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                    @escaping (UNNotificationPresentationOptions) -> Void) {
        segueToQuoteOfTheDay()
        completionHandler(UNNotificationPresentationOptions())
    }

    // MARK: - Helpers

    private func segueToQuoteOfTheDay() {
        if let rotatingNavVC = window?.rootViewController as? RotatingNavigationController {
            rotatingNavVC.dismiss(animated: true)
            
            if let quoteVC = rotatingNavVC.viewControllers.first as? QuoteViewController {
                quoteVC.showQuoteOfTheDay()
            }
        }
    }
}

