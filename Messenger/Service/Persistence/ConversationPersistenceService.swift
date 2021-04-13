//
//  ConversationPersistenceService.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation
import CoreData

class ConversationPersistenceService: IPersistenceConversationService {
	let coreDataStack: CoreDataStack
	let channelId: String
	
	private lazy var request: NSFetchRequest<MessageDB> = {
		let request: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
		let predicate = NSPredicate(format: "channel.id == %@", channelId)
		request.sortDescriptors = [sortDescriptor]
		request.predicate = predicate
		return request
	}()
	
	private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
		let context = coreDataStack.getMainContext()
		let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()
	
	var fetchedObjects: [NSManagedObject]? {
		fetchedResultsController.fetchedObjects
	}
	
	var sections: [NSFetchedResultsSectionInfo]? {
		fetchedResultsController.sections
	}
	
	func object(at indexPath: IndexPath) -> NSManagedObject {
		fetchedResultsController.object(at: indexPath)
	}
	
	func fetch() {
		do { try fetchedResultsController.performFetch() } catch { fatalError("unable to perform cached fetch") }
	}
	
	func performSave(messages: [ConversationModel.Message]) {
		coreDataStack.performSave { context in
//								guard let channelData = self?.channelData else { return }
			var messageManagedObjects = [NSManagedObject]()
			let channelManagedObject: ChannelDB?
			let channelRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
			channelRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
			channelRequest.predicate = NSPredicate(format: "id == %@", channelId)
			
			do {
				channelManagedObject = try context.fetch(channelRequest).first
			} catch { fatalError("unable to fetch channel for messages") }
			
			guard let existingMessageManagedObjects = fetchedObjects as? [MessageDB] else {
				fatalError("unable to get saved messages")
			}
			
			messages.forEach { message in
				if !existingMessageManagedObjects.contains(where: { $0.id == message.id }) {
					let messageManagedObject = MessageDB(for: message, in: context)
					messageManagedObjects.append(messageManagedObject)
					channelManagedObject?.addToMessages(messageManagedObject)
				}
			}
			do { try context.obtainPermanentIDs(for: messageManagedObjects) } catch {
				fatalError("Unable to get permanent ids for managed objects")
			}
		}
	}
	
	init(stack: CoreDataStack, id: String, delegate: NSFetchedResultsControllerDelegate) {
		coreDataStack = stack
		channelId = id
		
		fetchedResultsController.delegate = delegate
	}
}
