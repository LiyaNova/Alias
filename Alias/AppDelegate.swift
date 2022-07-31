//
//  AppDelegate.swift
//  Alias
//
//  Created by Olga on 26.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        window?.rootViewController = ScoreViewController()
        
        //ppNavigationController(rootViewController: TeamsMenuViewController(minNumberOfTeams: 2, maxNumberOfTeams: 10))
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

