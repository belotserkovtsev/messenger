//
//  CoreDataObjectExtensions.swift
//  Messenger
//
//  Created by belotserkovtsev on 29.03.2021.
//

import Foundation
import CoreData

extension ChannelDB {
	convenience init(id: String, name: String, lastMessage: String?, lastActivity: Date?, online: Bool, hasUnreadMessages: Bool, in context: NSManagedObjectContext) {
		self.init(context: context)
		
		self.id = id
		self.name = name
		self.lastMessage = lastMessage
		self.lastActivity = lastActivity
		self.online = online
		self.hasUnreadMessages = hasUnreadMessages
	}
	
	convenience init(for data: ChannelModel.Channel, in context: NSManagedObjectContext) {
		self.init(context: context)
		self.id = data.id
		self.name = data.name
		self.lastMessage = data.lastMessage
		self.lastActivity = data.lastActivity
		self.online = data.online
		self.hasUnreadMessages = data.hasUnreadMessages
	}
}
