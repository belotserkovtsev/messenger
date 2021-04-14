//
//  ServiceAssembly.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation
import CoreData

class ServiceAssembly {
	
	var conversationsBackendService: IFirestoreService {
		FirestoreService(path: "channels")
	}
	
	var profileFileService: IProfileFileService {
		ProfileFileService()
	}
	
	var initialSetupService: IInitialSetupService {
		InitialSetupService()
	}
	
	func conversationBackendService(for id: String) -> IFirestoreService {
		FirestoreService(path: "channels/\(id)/messages")
	}
	
	func conversationsPersistenceService(delegate: NSFetchedResultsControllerDelegate) -> IPersistenceConversationsService {
		ConversationsPersistenceService(stack: CoreAssembly().coreDataStack, delegate: delegate)
	}
	
	func conversationPersistenceService(id: String, delegate: NSFetchedResultsControllerDelegate) -> IPersistenceConversationService {
		ConversationPersistenceService(stack: CoreAssembly().coreDataStack, id: id, delegate: delegate)
	}
}
