//
//  AppDelegate.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
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
			// Форсы убрать не забыл. Так и хочу оставить, так как без этих файлов приложение работать будет не очень хорошо
			let storableData: ProfileDataStorable = .init(name: "Your name here", description: "Tell us something about yourself")
			let jsonData = try! JSONEncoder().encode(storableData)
			
			let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let profileDataBackupURL = documentDirURL.appendingPathComponent("ProfileDataBackup").appendingPathExtension("json")
			let profileDataURL = documentDirURL.appendingPathComponent("ProfileData").appendingPathExtension("json")
			
			try! jsonData.write(to: profileDataBackupURL)
			try! jsonData.write(to: profileDataURL)
			UserDefaults.standard.set(true, forKey: "isNthLaunch")
			return true
		}
	}
}

