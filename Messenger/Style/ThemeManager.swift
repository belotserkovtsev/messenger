//
//  ThemeManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 07.03.2021.
//

import UIKit

class ThemeManager: ThemeManagerDelegate {
	
	static var currentTheme: ThemeType {
		let themeRawValue = UserDefaults.standard.integer(forKey: "theme")
		if let theme = ThemeType(rawValue: themeRawValue) {
			return theme
		} else {
			return .light
		}
	}
	
	func didSelectTheme(_ theme: ThemeType) {
		switch theme {
		case .night:
			NightTheme().apply()
		case .light:
			LightTheme().apply()
		case .classic:
			ClassicTheme().apply()
		}
	}
}

public extension UIWindow {
	func reload() {
		subviews.forEach { view in
			view.removeFromSuperview()
			addSubview(view)
		}
		subviews.forEach { view in
			view.removeFromSuperview()
			addSubview(view)
		}
	}
}
