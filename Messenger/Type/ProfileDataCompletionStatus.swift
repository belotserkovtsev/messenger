//
//  CompletionStatus.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import Foundation

enum ProfileDataCompletionStatus {
	case success(data: ProfileDataModel?)
	case failure(error: Exception)
	case cancelled
}
