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
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
		
		if UserDefaults.standard.bool(forKey: "isNthLaunch") {
			return true
		} else {
			let profileData: ProfileDataModel = .init(name: "Your name here", description: "Tell us something about yourself", profilePicture: nil)
			GCDManager().save(data: profileData, isFirstLaunch: true) { result in
				print("ok")
			}
			UserDefaults.standard.set(true, forKey: "isNthLaunch")
			return true
		}
	}
}

