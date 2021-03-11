//
//  ThemeProtocol.swift
//  Messenger
//
//  Created by belotserkovtsev on 08.03.2021.
//

import UIKit

protocol ThemeProtocol {
	var navigationBarStyle: UIBarStyle { get }
	var navigationBarTextColor: UIColor { get }
	var navigationBarTint: UIColor { get }
	
	var mainViewsBackgroundColor: UIColor { get }
	var mainFontsColor: UIColor { get }
	var mainButtonsBackgroundColor: UIColor { get }
	
	var conversationsListUITableViewSeparatorColor: UIColor? { get }
	var conversationsListSelectedCellView: UIView? { get }
	var conversationsListCellBackgroundColor: UIColor { get }
	var conversationsListUITableViewBackgroundColor: UIColor { get }
//	var conversationsListUITableViewHeaderFooterView: UIView? { get }
	
	var conversationUITableViewBackgroundColor: UIColor? { get }
	var conversationCellBackgroundColor: UIColor? { get }
	var conversationCellIncomingBubbleBackgroundColor: UIColor { get }
	var conversationCellOutgoingBubbleBackgroundColor: UIColor { get }
	var conversationCellIncomingBubbleTextColor: UIColor { get }
	var conversationCellOutgoingBubbleTextColor: UIColor { get }
}

extension ThemeProtocol {
	func apply() {
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			//Dependent objects
			ThemeDependentUILabel.appearance()
				.textColor = mainFontsColor
			ThemeDependentUIView.appearance()
				.backgroundColor = mainViewsBackgroundColor
			ThemeDependentUIButton.appearance()
				.backgroundColor = mainButtonsBackgroundColor
			
			//Navbar
			UINavigationBar.appearance()
				.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationBarTextColor]
			UINavigationBar.appearance()
				.barStyle = navigationBarStyle
			
			//Conversations
			UITableViewCell.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self])
				.backgroundColor = conversationsListCellBackgroundColor
			UITableViewCell.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self])
				.selectedBackgroundView = conversationsListSelectedCellView
			
			UITableView.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self])
				.backgroundColor = conversationsListUITableViewBackgroundColor
			UITableView.appearance(whenContainedInInstancesOf: [ConversationsListViewController.self])
				.separatorColor = conversationsListUITableViewSeparatorColor
			
			//Conversation
			UITableViewCell.appearance(whenContainedInInstancesOf: [ConversationViewController.self])
				.backgroundColor = conversationCellBackgroundColor
			UITableView.appearance(whenContainedInInstancesOf: [ConversationViewController.self])
				.backgroundColor = conversationUITableViewBackgroundColor
			IncomingMessageUIView.appearance()
				.backgroundColor = conversationCellIncomingBubbleBackgroundColor
			OutgoingMessageUIView.appearance()
				.backgroundColor = conversationCellOutgoingBubbleBackgroundColor
			UILabel.appearance(whenContainedInInstancesOf: [IncomingMessageUIView.self])
				.textColor = conversationCellIncomingBubbleTextColor
			UILabel.appearance(whenContainedInInstancesOf: [OutgoingMessageUIView.self, IncomingMessageUIView.self])
				.textColor = conversationCellOutgoingBubbleTextColor
			
			appDelegate.window?.reload()
		}
	}
}
