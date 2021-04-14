//
//  InitialSetupService.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import Foundation

class InitialSetupService: IInitialSetupService {
	private let profileFileService: IProfileFileService
	private let theme: ThemeType
	
	func firstLaunchSetup() {
		if UserDefaults.standard.bool(forKey: "isNthLaunch") {
			return
		}
		
		let profileData: ProfileDataModel = .init(name: "Your name here", description: "Tell us something about yourself", profilePicture: nil)
		profileFileService.write(data: profileData, isFirstLaunch: true) { _ in }
		UserDefaults.standard.set(true, forKey: "isNthLaunch")
	}
	
	func anyLaunchSetup() {
		switch theme {
		case .light:
			LightTheme().apply()
		case .night:
			NightTheme().apply()
		case .classic:
			ClassicTheme().apply()
		}
	}
	
	init() {
		let serviceAssembly = ServiceAssembly()
		let presentationAssembly = PresentationAssembly()
		profileFileService = serviceAssembly.profileFileService
		theme = presentationAssembly.currentTheme
	}
}
