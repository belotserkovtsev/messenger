//
//  CoreDataStack.swift
//  Messenger
//
//  Created by belotserkovtsev on 29.03.2021.
//

import Foundation
import CoreData

class CoreDataStack {
	static let shared = CoreDataStack()
	private var storeURL: URL = {
		guard let documentsURL = FileManager.default.urls(for: .documentDirectory,
														  in: .userDomainMask).last else {
			fatalError("unexpected error")
		}
		return documentsURL.appendingPathComponent("Chat.sqlite")
	}()
	
	private let dataModelName = "Chat"
	private let dataModelExtension = "momd"
	
	private lazy var managedObjectModel: NSManagedObjectModel = {
		guard let modelURL = Bundle.main.url(forResource: dataModelName, withExtension: dataModelExtension),
			  let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("unexpected error") }
		return managedObjectModel
	}()
	
	private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		
		do {
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
		} catch {
			fatalError(error.localizedDescription)
		}
		
		return coordinator
	}()
	
	private lazy var writterContext: NSManagedObjectContext = {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		context.persistentStoreCoordinator = persistentStoreCoordinator
		context.mergePolicy = NSOverwriteMergePolicy
		return context
	}()
	
	private lazy var mainContext: NSManagedObjectContext = {
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.parent = writterContext
		context.automaticallyMergesChangesFromParent = true
		context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		return context
	}()
	
	private func saveContext() -> NSManagedObjectContext {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		context.parent = mainContext
		context.automaticallyMergesChangesFromParent = true
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		return context
	}
	
	func performSave(_ block: (NSManagedObjectContext) -> Void) {
		let context = saveContext()
		context.performAndWait {
			block(context)
			if context.hasChanges {
				performSave(in: context)
			}
		}
	}
	
	private func performSave(in context: NSManagedObjectContext) {
		context.performAndWait {
			do { try context.save() } catch { assertionFailure(error.localizedDescription) }
		}
		if let parent = context.parent { performSave(in: parent) }
		
//		printDatabaseStatistics()
	}
	
	func getMainContext() -> NSManagedObjectContext {
		mainContext
	}
	
	func printDatabaseStatistics() {
		mainContext.perform {
			do {
				let count = try self.mainContext.count(for: ChannelDB.fetchRequest())
				print("\(count) каналов")
				let channels = try self.mainContext.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
				channels.forEach {
					print($0.about)
				}
			} catch {
				fatalError(error.localizedDescription)
			}
		}
	}
	
	func enableObservers() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
									   selector: #selector(managedObjectContextObjectsDidChange(notification:)),
									   name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
									   object: mainContext)
	}
	
	@objc
	private func managedObjectContextObjectsDidChange(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		
		if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
		   inserts.count > 0 {
			print("Добавлено объектов: ", inserts.count)
		}
		
		if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
		   updates.count > 0 {
			print("Обновлено объектов: ", updates.count)
		}
		
		if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
		   deletes.count > 0 {
			print("Удалено объектов: ", deletes.count)
		}
	}
}
