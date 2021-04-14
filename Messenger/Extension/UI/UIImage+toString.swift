//
//  UIImage+toString.swift
//  Messenger
//
//  Created by belotserkovtsev on 16.03.2021.
//

import UIKit

extension UIImage {
	func toString() -> String? {
		let pngData = self.pngData()
		return pngData?.base64EncodedString(options: .lineLength64Characters)
	}
}
