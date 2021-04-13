//
//  IPersistenceConversationService.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation

protocol IPersistenceConversationService: IPersistenceService {
	func performSave(messages: [ConversationModel.Message])
}
