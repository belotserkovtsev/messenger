//
//  ThemesViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 04.03.2021.
//

import UIKit

class ThemesViewController: UIViewController {
	var themeDelegate: ThemeManagerDelegate?
//	var themeHandler: ((ThemeType) -> ())?
	
	@IBOutlet weak var nightThemeView: UIView?
	@IBOutlet weak var lightThemeView: UIView?
	@IBOutlet weak var classicThemeView: UIView?
	@IBOutlet weak var nightThemeStack: UIStackView?
	@IBOutlet weak var lightThemeStack: UIStackView?
	@IBOutlet weak var classicThemeStack: UIStackView?
	@IBOutlet var messageBubbleViews: [UIView]?
	
	let defaults = UserDefaults.standard
	
	@objc func nightThemeTouchHandler() {
		themeDelegate?.didSelectTheme(.night)
//		themeHandler?(.night)
		setSelection(for: .night)
	}
	@objc func lightThemeTouchHandler() {
		themeDelegate?.didSelectTheme(.light)
//		themeHandler?(.light)
		setSelection(for: .light)
	}
	
	@objc func classicThemeTouchHandler() {
		themeDelegate?.didSelectTheme(.classic)
//		themeHandler?(.classic)
		setSelection(for: .classic)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		nightThemeView?.layer.cornerRadius = 14
		nightThemeView?.layer.borderWidth = 1
		nightThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		lightThemeView?.layer.cornerRadius = 14
		lightThemeView?.layer.borderWidth = 1
		lightThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		classicThemeView?.layer.cornerRadius = 14
		classicThemeView?.layer.borderWidth = 1
		classicThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		if let bubbles = messageBubbleViews {
			for bubble in bubbles {
				bubble.layer.cornerRadius = 8
			}
		}
		
		title = "Themes"
		
		let nightThemeTap = UITapGestureRecognizer(target: self, action: #selector(nightThemeTouchHandler))
		nightThemeStack?.addGestureRecognizer(nightThemeTap)
		
		let lightThemeTap = UITapGestureRecognizer(target: self, action: #selector(lightThemeTouchHandler))
		lightThemeStack?.addGestureRecognizer(lightThemeTap)
		
		let classicThemeTap = UITapGestureRecognizer(target: self, action: #selector(classicThemeTouchHandler))
		classicThemeStack?.addGestureRecognizer(classicThemeTap)
		
		let themeRawValue = defaults.integer(forKey: "theme")
		if let theme = ThemeType(rawValue: themeRawValue) {
			setSelection(for: theme)
		} else {
			setSelection(for: .light)
		}
		
		themeDelegate = ThemeManager()
//		themeHandler = ThemeManager().didSelectTheme(_:)
	}
	
	private func setSelection(for theme: ThemeType) {
		clearSelection()
		switch theme {
		case .light:
			lightThemeView?.layer.borderWidth = 3
			lightThemeView?.layer.borderColor = UIColor.themeSelectedBorder.cgColor
			defaults.set(ThemeType.light.rawValue, forKey: "theme")
		case .night:
			nightThemeView?.layer.borderWidth = 3
			nightThemeView?.layer.borderColor = UIColor.themeSelectedBorder.cgColor
			defaults.set(ThemeType.night.rawValue, forKey: "theme")
		case .classic:
			classicThemeView?.layer.borderWidth = 3
			classicThemeView?.layer.borderColor = UIColor.themeSelectedBorder.cgColor
			defaults.set(ThemeType.classic.rawValue, forKey: "theme")
		}
	}
	
	private func clearSelection() {
		nightThemeView?.layer.borderWidth = 1
		nightThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		lightThemeView?.layer.borderWidth = 1
		lightThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		classicThemeView?.layer.borderWidth = 1
		classicThemeView?.layer.borderColor = UIColor.themeBorder.cgColor
	}
}

enum ThemeType: Int {
	case light, night, classic
}
