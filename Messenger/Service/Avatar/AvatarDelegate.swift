//
//  AvatarDelegate.swift
//  Messenger
//
//  Created by belotserkovtsev on 20.04.2021.
//

import UIKit

protocol AvatarDelegate: AnyObject {
	func didSelectAvatar(image: UIImage?)
}
