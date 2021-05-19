//
//  AvatarServiceMock.swift
//  MessengerTests
//
//  Created by belotserkovtsev on 04.05.2021.
//

@testable import Messenger
import UIKit

class AvatarServiceMock: IAvatarService {
	var imageStub: () -> UIImage
	let imagesCount = 5
	var calls = 0
	
	func getAvatars(count: ((Int) -> Void)?, completion: ((Result<(UIImage, Int), AvatarError>) -> Void)?) {
		calls += 1
		count?(imagesCount)
		for i in 0..<imagesCount {
			completion?(.success((imageStub(), i)))
		}
	}
	
	init(imageStub: @escaping () -> UIImage) {
		self.imageStub = imageStub
	}
}
