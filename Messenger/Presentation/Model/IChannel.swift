//
//  IChannel.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.04.2021.
//

import Foundation

protocol IChannel {
	var id: String { get }
	var name: String { get }
	var lastMessage: String? { get }
	var lastActivity: Date? { get }
	var online: Bool { get }
	var hasUnreadMessages: Bool { get }
}
