//
//  PixabayData.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import Foundation

struct PixabayData: Codable {
	var hits: [Image]
	
	struct Image: Codable {
		var previewURL: URL
		var webformatURL: URL
	}
}
