//
//  Console.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import Foundation

class Console {
	static var enableLogging: Bool { get { true } }
	
	static func conditionalLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
		if enableLogging {
			for i in items.indices {
				print(items[i],
					  separator: separator,
					  terminator: i == (items.endIndex - 1) ? terminator : separator
				)
			}
		}
	}
}
