//
//  AppDelegate.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		let initialViewController = ConversationsListViewController.make()
		let navigationController = UINavigationController(rootViewController: initialViewController)
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		
		if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
		
		let theme = ThemeManager.currentTheme
		switch theme {
		case .light:
			LightTheme().apply()
		case .night:
			NightTheme().apply()
		case .classic:
			ClassicTheme().apply()
		}
		return true
	}
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		if UserDefaults.standard.bool(forKey: "isNthLaunch") {
			return true
		} else {
			let profileData: ProfileDataModel = .init(name: "Your name here", description: "Tell us something about yourself", profilePicture: nil)
			GCDManager().save(data: profileData, isFirstLaunch: true) { _ in }
			UserDefaults.standard.set(true, forKey: "isNthLaunch")
			return true
		}
	}
}
