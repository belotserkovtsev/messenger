//
//  InitialSetupService.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import UIKit

class InitialSetupService: IInitialSetupService {
	private let profileFileService: IProfileFileService
	private let theme: ThemeType
	private var window: UIWindow?
	
	var initialViewController: UIViewController? {
		if UserDefaults.standard.bool(forKey: "isNthLaunch") {
			guard let initialViewController = ConversationsListViewController.make() else { return nil }
			let navigationController = UINavigationController(rootViewController: initialViewController)
			return navigationController
		} else {
			return AboutAppViewController.make(at: 0)
		}
	}
	
	func launchSetup() -> UIWindow? {
		if UserDefaults.standard.bool(forKey: "isNthLaunch") {
			anyLaunchSetup()
			return window
		} else {
			firstLaunchSetup()
			return window
		}
	}
	
	func completeOnboarding() {
		anyLaunchSetup()
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate?.window = window
	}
	
	private func firstLaunchSetup() {
		anyLaunchSetup()
		let profileData: ProfileModel = .init(name: "Your name here", description: "Tell us something about yourself", profilePicture: nil)
		profileFileService.write(data: profileData, isFirstLaunch: true) { _ in }
		UserDefaults.standard.set(true, forKey: "isNthLaunch")
	}
	
	private func anyLaunchSetup() {
		setWindowWithCurrentInitialVc()
		if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
		switch theme {
		case .light:
			LightTheme().apply()
		case .night:
			NightTheme().apply()
		case .classic:
			ClassicTheme().apply()
		}
	}
	
	private func setWindowWithCurrentInitialVc() {
		guard let initialViewController = initialViewController else { fatalError("unable to set window") }
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = initialViewController
		self.window?.makeKeyAndVisible()
	}
	
	init() {
		let serviceAssembly = ServiceAssembly()
		let presentationAssembly = PresentationAssembly()
		profileFileService = serviceAssembly.profileFileService
		theme = presentationAssembly.currentTheme
	}
}
