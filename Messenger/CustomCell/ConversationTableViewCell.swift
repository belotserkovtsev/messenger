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
		messageTextLabel?.text = data.text
		
		switch data.messageType {
		case .incoming:
			trailingPaddingConstraint?.isActive = false
			leadingPaddingConstraint?.isActive = true
			messageView?.backgroundColor = UIColor(named: "IncomingMessage") ?? .gray
		case .outgoing:
			trailingPaddingConstraint?.isActive = true
			leadingPaddingConstraint?.isActive = false
			messageView?.backgroundColor = UIColor(named: "OutgoingMessage") ?? .green
		}
	}
    
}
