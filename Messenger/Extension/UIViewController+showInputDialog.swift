//
//  UIViewController+showInputDialog.swift
//  Messenger
//
//  Created by belotserkovtsev on 23.03.2021.
//

import UIKit

extension UIViewController {
	func showInputDialog(title:String? = nil,
						 subtitle:String? = nil,
						 actionTitle:String? = "Add",
						 cancelTitle:String? = "Cancel",
						 inputPlaceholder:String? = nil,
						 inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
						 actionHandler: ((String?) -> Void)? = nil) {
		
		let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = inputPlaceholder
			textField.keyboardType = inputKeyboardType
		}
		alert.addAction(UIAlertAction(title: actionTitle, style: .default) { action in
			guard let textField =  alert.textFields?.first,
				  let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
				actionHandler?(nil)
				return
			}
			actionHandler?(text)
		})
		alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
}
