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
	@IBOutlet weak var fromLabel: ThemeDependentUILabel?
	
	func configure(with data: ConversationViewController.ConversationDataModel.Message) {
		incomingMessageView?.layer.cornerRadius = 12
		outgoingMessageView?.layer.cornerRadius = 12
		
		outgoingMessageTextLabel?.text = data.text
		incomingMessageTextLabel?.text = data.text
		outgoingMessageTextLabel?.font = UIFont.systemFont(ofSize: 16)
		incomingMessageTextLabel?.font = UIFont.systemFont(ofSize: 16)
		
		fromLabel?.text = data.senderName
		
		switch data.messageType {
		case .incoming:
			trailingPaddingConstraint?.isActive = false
			leadingPaddingConstraint?.isActive = true
			outgoingMessageView?.isHidden = true
			fromLabel?.isHidden = false
		case .outgoing:
			trailingPaddingConstraint?.isActive = true
			leadingPaddingConstraint?.isActive = false
			outgoingMessageView?.isHidden = false
			fromLabel?.isHidden = true
		}
	}
    
}
