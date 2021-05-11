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
		
		window = initialSetupService.launchSetup()
		
		return true
	}
	
	override init() {
		initialSetupService = ServiceAssembly().initialSetupService
	}
}
