//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by belotserkovtsev on 01.03.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
	@IBOutlet weak var messageTextLabel: UILabel?
	@IBOutlet weak var messageView: UIView?
	@IBOutlet var trailingPaddingConstraint: NSLayoutConstraint?
	@IBOutlet var leadingPaddingConstraint: NSLayoutConstraint?
	
	func configure(with data: ConversationViewController.ConversationDataModel.Message) {
		messageView?.layer.cornerRadius = 12
		if let text = data.text {
			messageTextLabel?.text = text
			messageTextLabel?.font = UIFont.systemFont(ofSize: 16)
		} else {
			messageTextLabel?.text = "Unable to load message"
			messageTextLabel?.font = UIFont.italicSystemFont(ofSize: 16)
		}
		
		switch data.messageType {
		case .incoming:
			trailingPaddingConstraint?.isActive = false
			leadingPaddingConstraint?.isActive = true
			messageView?.backgroundColor = UIColor(named: "IncomingMessageBubble") ?? .gray
			messageTextLabel?.textColor = UIColor(named: "IncomingMessageText") ?? .black
		case .outgoing:
			trailingPaddingConstraint?.isActive = true
			leadingPaddingConstraint?.isActive = false
			messageView?.backgroundColor = UIColor(named: "OutgoingMessageBubble") ?? .green
			messageTextLabel?.textColor = .white
		}
	}
    
}
