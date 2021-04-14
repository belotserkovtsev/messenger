//
//  UIWindow+reload.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import UIKit

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
