//
//  CoreDataFactory.swift
//  Messenger
//
//  Created by belotserkovtsev on 31.03.2021.
//

import Foundation

class CoreDataManager: CoreDataStack {
	static let stack = CoreDataManager()
	
	private override init() {
		super.init()
		enableObservers()
	}
}
