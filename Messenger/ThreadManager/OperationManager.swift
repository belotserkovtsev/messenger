//
//  OperationManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 18.03.2021.
//

import Foundation

class OperationManager {
	private var saveOperation: SaveOperation?
	private let queue = OperationQueue()
	
	func save(data: ProfileDataModel, completion: @escaping (ProfileDataCompletionStatus) -> ()) {
		saveOperation = SaveOperation()
		saveOperation?.dataModel = data
		saveOperation?.completionBlock = { [weak self] in
			switch self?.saveOperation?.currentState {
			case .finished:
				DispatchQueue.main.async {
					completion(.success(data: nil))
				}
			case .cancelled:
				DispatchQueue.main.async {
					completion(.cancelled)
				}
			default:
				print("undefined")
			}
			self?.saveOperation = nil
		}
		queue.qualityOfService = .userInitiated
		queue.maxConcurrentOperationCount = Int.max
		queue.addOperation(saveOperation!)
	}
	
	func cancel() {
		saveOperation?.cancel()
	}
}
