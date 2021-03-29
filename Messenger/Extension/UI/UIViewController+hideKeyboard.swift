//
//  UIViewController+hideKeyboard.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() -> UIGestureRecognizer {
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		return tap
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
