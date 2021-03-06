//
//  LightTheme.swift
//  Messenger
//
//  Created by belotserkovtsev on 10.03.2021.
//

import UIKit

class LightTheme: ThemeProtocol {
	
	var navigationBarStyle: UIBarStyle = .default
	
	var navigationBarTextColor: UIColor = .black
	
	var navigationBarTint: UIColor = .white
	
	var mainViewsBackgroundColor: UIColor = .white
	
	var mainFontsColor: UIColor = .black
	
	var mainButtonsBackgroundColor: UIColor = .lightButton
	
	var conversationsListUITableViewSeparatorColor: UIColor?
	
	var conversationsListSelectedCellView: UIView?
	
	var conversationsListCellBackgroundColor: UIColor = .white
	
	var conversationUITableViewBackgroundColor: UIColor?
	
	var conversationCellBackgroundColor: UIColor?
	
	var conversationCellIncomingBubbleBackgroundColor: UIColor = .lightIncomingBubble
	
	var conversationCellOutgoingBubbleBackgroundColor: UIColor = .lightOutgoingBubble
	
	var conversationCellIncomingBubbleTextColor: UIColor = .black
	
	var conversationCellOutgoingBubbleTextColor: UIColor = .white
	
}
