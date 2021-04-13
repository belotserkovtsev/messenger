//
//  IConversationsSaveble.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation

protocol IPersistenceConversationsService: IPersistenceService {
	func performSave(channels: [ChannelModel.Channel])
}
