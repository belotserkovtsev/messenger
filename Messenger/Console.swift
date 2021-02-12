//
//  Console.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import Foundation

class Console {
	static var enableLogging: Bool { get { true } }
	
	static func log(_ data: Any) {
		if enableLogging {
			print(data)
		}
	}
}
