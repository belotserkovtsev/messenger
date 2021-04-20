//
//  CompletionStatus.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import Foundation

enum ProfileDataCompletionStatus {
	case success(data: ProfileModel?)
	case failure(error: Exception)
	case cancelled
}
