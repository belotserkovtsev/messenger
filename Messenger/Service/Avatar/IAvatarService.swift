//
//  IAvatarService.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit

protocol IAvatarService {
	func getAvatars(count: ((Int) -> Void)?, completion: ((Result<(UIImage, Int), AvatarError>) -> Void)?)
}
