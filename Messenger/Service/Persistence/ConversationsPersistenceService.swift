//
//  PersistenceService.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import UIKit
import CoreData

class ConversationsPersistenceService: IPersistenceService {
	typealias DataModelType = ChannelModel.Channel
	
	private let coreDataStack: CoreDataStack
	
	private lazy var request: NSFetchRequest<ChannelDB> = {
		let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
		request.sortDescriptors = [sortDescriptor]
		return request
	}()
	
	private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
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
	
	func performSave<DataModelType>(data: [DataModelType]) {
		guard let data = data as? [ChannelModel.Channel] else { return }
		coreDataStack.performSave { context in
			var managedObjects = [NSManagedObject]()
			var channelManagedObjects = [ChannelDB]()
			let channelRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
			channelRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
			
			do { channelManagedObjects = try context.fetch(channelRequest) } catch { fatalError("unable to fetch channel for messages") }
			
			if !channelManagedObjects.isEmpty {
				
				// check wether saved channels contain listener channels to create mismatched objects and update
				// existing ones
				for channel in data {
					if let channelManagedObject = channelManagedObjects.first(where: { $0.id == channel.id }) {
						channelManagedObject.update(with: channel)
					} else {
						managedObjects.append(ChannelDB(for: channel, in: context))
					}
				}
				
				do { try context.obtainPermanentIDs(for: managedObjects) } catch {
					fatalError("Unable to get permanent ids for managed objects")
				}
				
				// check wether listener channels contain saved channels to delete mismatches
				for channelManagedObject in channelManagedObjects {
					if !data.contains(where: { $0.id == channelManagedObject.id }) {
						context.delete(channelManagedObject)
					}
				}
				
			} else {
				for channel in data {
					managedObjects.append(ChannelDB(for: channel, in: context))
				}
				do { try context.obtainPermanentIDs(for: managedObjects) } catch {
					fatalError("Unable to get permanent ids for managed objects")
				}
			}
		}
	}
	
	init(stack: CoreDataStack, delegate: NSFetchedResultsControllerDelegate) {
		coreDataStack = stack
		fetchedResultsController.delegate = delegate
	}
}
