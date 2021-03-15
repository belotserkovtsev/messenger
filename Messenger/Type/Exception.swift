//
//  Exception.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import Foundation

struct Exception {
	var id: Int
	var message: String
	
	init(id: Int, message: String = "Something went wrong. Try again maybe?") {
		self.id = id
		self.message = message
	}
}
