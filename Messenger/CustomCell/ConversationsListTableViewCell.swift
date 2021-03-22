//
//  ConversationsListTableViewCell.swift
//  Messenger
//
//  Created by belotserkovtsev on 28.02.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var profilePictureView: UIView?
	@IBOutlet weak var nameAndLastnameLabel: ThemeDependentUILabel?
	@IBOutlet weak var lastMessageLabel: UILabel?
	@IBOutlet weak var initialsLabel: ThemeDependentUILabel?
	@IBOutlet weak var unreadMessageIndicator: UIView?
	@IBOutlet weak var isOnlineView: UIView?
	@IBOutlet weak var isOnlineStrokeView: UIView?
	@IBOutlet weak var dateLabel: UILabel?
	
	func configure(with data: ConversationsListViewController.ChannelDataModel.Channel) {
		profilePictureView?.layer.cornerRadius = 52 / 2
		unreadMessageIndicator?.layer.cornerRadius = 14 / 2
		isOnlineView?.layer.cornerRadius = 12 / 2
		isOnlineStrokeView?.layer.cornerRadius = 16 / 2
		isOnlineStrokeView?.backgroundColor = .white
		
		nameAndLastnameLabel?.text = data.name ?? "No name"
		lastMessageLabel?.text = data.message ?? "No messages yet..."
		initialsLabel?.text = "\(data.name?.first?.uppercased() ?? "")"
		isOnlineView?.isHidden = !data.online
		isOnlineStrokeView?.isHidden = !data.online
		dateLabel?.text = date(for: data.date)
		
		if data.hasUnreadMessages {
			setCellToUnread()
		} else {
			setCellToRead()
		}
	}
	
	private func setCellToRead() {
		lastMessageLabel?.font = UIFont.systemFont(ofSize: 13)
		unreadMessageIndicator?.isHidden = true
	}
	
	private func setCellToUnread() {
		lastMessageLabel?.font = UIFont.boldSystemFont(ofSize: 13)
		unreadMessageIndicator?.isHidden = false
	}
	
	private func date(for input: Date?) -> String? {
		let formatter = DateFormatter()
		if let inputDate = input {
			let calendar = Calendar.current
			let startOfNow = calendar.startOfDay(for: Date())
			let startOfTimeStamp = calendar.startOfDay(for: inputDate)
			let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
			let dayComponent = components.day
			if let day = dayComponent {
				if abs(day) >= 1 {
					formatter.dateFormat = "dd MMM"
				} else {
					formatter.dateFormat = "HH:mm"
				}
			}
			return formatter.string(from: inputDate)
		}
		
		return ""
	}
}
