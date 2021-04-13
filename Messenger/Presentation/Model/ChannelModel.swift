//
//  ChannelModel.swift
//  Messenger
//
//  Created by belotserkovtsev on 29.03.2021.
//

import Foundation

struct ChannelModel {
	private(set) var channels = [Channel]()
	
	mutating func reload(with channels: [Channel]) {
		self.channels = channels.sorted { left, right in
			guard let leftLatestActivity = left.lastActivity else { return false }
			guard let rigtLatestActivity = right.lastActivity else { return true }
			return leftLatestActivity > rigtLatestActivity
		}
	}
	
	struct Channel {
		var id: String
		var name: String
		var lastMessage: String?
		var lastActivity: Date?
		var online: Bool
		var hasUnreadMessages: Bool
	}
}
