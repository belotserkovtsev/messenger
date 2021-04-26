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
	private let initialSetupService: IInitialSetupService
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		guard let initialViewController = ConversationsListViewController.make() else { return true }
		let navigationController = UINavigationController(rootViewController: initialViewController)
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		
		if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
		
		initialSetupService.anyLaunchSetup()
		return true
	}
	
	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		initialSetupService.firstLaunchSetup()
		return true
	}
	
	override init() {
		initialSetupService = ServiceAssembly().initialSetupService
	}
}
