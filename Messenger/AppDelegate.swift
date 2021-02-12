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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
	
	//MARK: State tracking
	func applicationWillResignActive(_ application: UIApplication) {
		Console.log("Application moved from active to inactive: \(#function)")
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		Console.log("Application moved from inactive to background: \(#function)")
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		Console.log("Application moved from background to inactive: \(#function)")
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		Console.log("Application moved from inactive to active: \(#function)")
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		Console.log("Application will be terminated")
	}

	
	


}

