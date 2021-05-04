//
//  ImageSelectionModel.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit

struct ImageSelectionModel {
	var images = [UIImage?]()
	
	mutating func willLoad(count: Int) {
		for _ in 0..<count {
			images.append(nil)
		}
	}
	
	mutating func update(with image: UIImage, at index: Int) {
		images[index] = image
	}
	
	mutating func unableToLoad(at index: Int) {
		images[index] = nil
	}
	
	func image(for indexPath: IndexPath) -> UIImage? {
		images[indexPath.row]
	}
}
