//
//  UIScrollView+scrollToBottom.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import UIKit

extension UIScrollView {
	func scrollToBottom(animated: Bool) {
		if self.contentSize.height < self.bounds.size.height { return }
		let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
		self.setContentOffset(bottomOffset, animated: animated)
	}
}