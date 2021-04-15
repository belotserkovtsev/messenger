//
//  ConversationModel.swift
//  Messenger
//
//  Created by belotserkovtsev on 29.03.2021.
//

import Foundation

// MARK: Data
struct ConversationModel {
	private(set) var messages = [Message]()
	
	mutating func reload(with data: [Message]) {
		messages = data.sorted { $0.created < $1.created }
	}
	
	mutating func append(message: Message) {
		messages.append(message)
	}
	
	mutating func clear() {
		messages = [Message]()
	}
	
	struct Message: IMessage {
		var id: String
		var text: String
		var created: Date
		var senderId: String
		var senderName: String
		
		var messageType: MessageType
	}
}
