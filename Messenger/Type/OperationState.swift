//
//  OperationState.swift
//  Messenger
//
//  Created by belotserkovtsev on 18.03.2021.
//

import Foundation

enum OperationState: String {
	case ready, executing, cancelled, finished
	var keyPath: String {
		"is\(rawValue.capitalized)"
	}
}
