//
//  IMessage.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.04.2021.
//

import Foundation

protocol IMessage {
	var id: String { get }
	var text: String { get }
	var created: Date { get }
	var senderId: String { get }
	var senderName: String { get }
	
	var messageType: MessageType { get }
}
