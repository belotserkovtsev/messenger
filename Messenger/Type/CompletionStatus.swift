//
//  CompletionStatus.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import Foundation

enum CompletionStatus {
	case success
	case failure(error: Exception)
}
