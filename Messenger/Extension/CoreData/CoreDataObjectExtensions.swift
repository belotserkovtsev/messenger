//
//  CoreDataObjectExtensions.swift
//  Messenger
//
//  Created by belotserkovtsev on 29.03.2021.
//

import Foundation
import CoreData

extension ChannelDB {
	convenience init(id: String, name: String, lastMessage: String?, lastActivity: Date?, hasUnreadMessages: Bool, in context: NSManagedObjectContext) {
		self.init(context: context)
		
		self.id = id
		self.name = name
		self.lastMessage = lastMessage
		self.lastActivity = lastActivity
		self.hasUnreadMessages = hasUnreadMessages
	}
	
	convenience init(for data: IChannel, in context: NSManagedObjectContext) {
		self.init(context: context)
		self.id = data.id
		self.name = data.name
		self.lastMessage = data.lastMessage
		self.lastActivity = data.lastActivity
		self.hasUnreadMessages = data.hasUnreadMessages
	}
	
	func update(with data: IChannel) {
		lastMessage = data.lastMessage
		lastActivity = data.lastActivity
		hasUnreadMessages = data.hasUnreadMessages
	}
	
	var about: String {
		let description = "\(String(describing: name)) \n"
		let messages = self.messages?.allObjects
			.compactMap { $0 as? MessageDB }
			.map { "\t\t\t\($0.about)" }
			.joined(separator: "\n") ?? ""
		
		return description + messages
	}
}

extension MessageDB {
	convenience init(id: String, text: String, senderID: String, created: Date, senderName: String, in context: NSManagedObjectContext) {
		self.init(context: context)
		
		self.id = id
		self.text = text
		self.senderID = senderID
		self.created = created
		self.senderName = senderName
	}
	
	convenience init(for data: IMessage, in context: NSManagedObjectContext) {
		self.init(context: context)
		
		self.id = data.id
		self.text = data.text
		self.senderID = data.senderId
		self.created = data.created
		self.senderName = data.senderName
	}
	
	var about: String {
		return "message: \(String(describing: text))"
	}
}
