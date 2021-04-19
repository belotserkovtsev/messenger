//
//  CoreDataComplianceExtensions.swift
//  Messenger
//
//  Created by belotserkovtsev on 05.04.2021.
//

import Foundation
import UIKit

extension ChannelModel.Channel {
	// Хочу оставить эти поля с форсами, т.к они быть ДОЛЖНЫ, а если их нет - это unexpected behaviour и я не могу
	// гарантировать стабильную работу приложения
	init(for data: ChannelDB) {
		id = data.id!
		name = data.name!
		lastMessage = data.lastMessage
		lastActivity = data.lastActivity
		online = lastActivity?.hasPassedSinceNow(for: .minute, duration: 10) ?? false
		hasUnreadMessages = false
	}
}

extension ConversationModel.Message {
	init(for data: MessageDB) {
		id = data.id!
		created = data.created!
		senderId = data.senderID!
		senderName = data.senderName!
		text = data.text!
		let isOutgoing = data.senderID! == UIDevice.current.identifierForVendor?.uuidString
		messageType = isOutgoing ? .outgoing : .incoming
	}
}
