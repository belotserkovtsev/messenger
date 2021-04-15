//
//  IConversationsPersistenceService.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation
import CoreData

protocol IPersistenceService {
	var sections: [NSFetchedResultsSectionInfo]? { get }
	var fetchedObjects: [NSManagedObject]? { get }
	func fetch()
	func object(at indexPath: IndexPath) -> NSManagedObject
	func performSave<DataModelType>(data: [DataModelType])
}
