//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by belotserkovtsev on 01.03.2021.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
	@IBOutlet weak var outgoingMessageTextLabel: UILabel?
	@IBOutlet weak var incomingMessageTextLabel: UILabel?
	@IBOutlet weak var incomingMessageView: IncomingMessageUIView?
	@IBOutlet weak var outgoingMessageView: OutgoingMessageUIView?
	@IBOutlet var trailingPaddingConstraint: NSLayoutConstraint?
	@IBOutlet var leadingPaddingConstraint: NSLayoutConstraint?
	
	func configure(with data: ConversationViewController.ConversationDataModel.Message) {
		incomingMessageView?.layer.cornerRadius = 12
		outgoingMessageView?.layer.cornerRadius = 12
		if let text = data.text {
			outgoingMessageTextLabel?.text = text
			incomingMessageTextLabel?.text = text
			outgoingMessageTextLabel?.font = UIFont.systemFont(ofSize: 16)
			incomingMessageTextLabel?.font = UIFont.systemFont(ofSize: 16)
		} else {
			outgoingMessageTextLabel?.text = "Unable to load message"
			incomingMessageTextLabel?.text = "Unable to load message"
			outgoingMessageTextLabel?.font = UIFont.italicSystemFont(ofSize: 16)
			incomingMessageTextLabel?.font = UIFont.italicSystemFont(ofSize: 16)
		}
		
		switch data.messageType {
		case .incoming:
			trailingPaddingConstraint?.isActive = false
			leadingPaddingConstraint?.isActive = true
			outgoingMessageView?.isHidden = true
		case .outgoing:
			trailingPaddingConstraint?.isActive = true
			leadingPaddingConstraint?.isActive = false
			outgoingMessageView?.isHidden = false
		}
	}
    
}
