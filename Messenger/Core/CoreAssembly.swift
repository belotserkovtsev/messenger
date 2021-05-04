//
//  CoreAssembly.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation

class CoreAssembly {
	var coreDataStack: CoreDataStack {
		CoreDataStack.shared
	}
	
	var userDefaults: UserDefaults {
		UserDefaults.standard
	}
	
	var networkTask: INetworkTask {
		NetworkTask(session: .init(configuration: .default))
	}
}
