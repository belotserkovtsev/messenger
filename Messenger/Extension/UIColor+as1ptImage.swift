//
//  UIImage+as1ptImage.swift
//  Messenger
//
//  Created by belotserkovtsev on 08.03.2021.
//

import UIKit

extension UIColor {
	
	/// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
	///
	/// - Returns: `self` as a 1x1 `UIImage`.
	func as1ptImage() -> UIImage {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		setFill()
		UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
		UIGraphicsEndImageContext()
		return image
	}
}
