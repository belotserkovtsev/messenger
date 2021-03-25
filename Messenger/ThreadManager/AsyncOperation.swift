//
//  OperationsManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 18.03.2021.
//

import Foundation

class AsyncOperation: Operation {
	var currentState = OperationState.ready {
		willSet {
			willChangeValue(forKey: currentState.keyPath)
			willChangeValue(forKey: newValue.keyPath)
		}
		didSet {
			didChangeValue(forKey: oldValue.keyPath)
			didChangeValue(forKey: currentState.keyPath)
		}
	}
	
	override var isAsynchronous: Bool {
		true
	}
	
	override var isExecuting: Bool {
		currentState == .executing
	}
	
	override var isCancelled: Bool {
		currentState == .cancelled
	}
	
	override var isFinished: Bool {
		currentState == .finished
	}
	
	override func start() {
		if isCancelled {
			return
		}
		currentState = .executing
		main()
	}
	override func cancel() {
		currentState = .cancelled
	}
}
