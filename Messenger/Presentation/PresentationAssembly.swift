//
//  PresentationAssembly.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import Foundation

class PresentationAssembly {
	var currentTheme: ThemeType {
		ThemeService.currentTheme
	}
	
	var onboardingDataSource: [AboutAppModel] =
		[.init(title: "Welcome to Messenger",
			   description: "It's a simple open source app which allows you to chat with your friends, collegues and family",
			   buttonTitle: "Nice!",
			   isInteractive: false),
		 .init(title: "Don't be shy, put your finger on the screen 🤔",
			   description: nil,
			   buttonTitle: "Oh, that's cool",
			   isInteractive: true)]
}
