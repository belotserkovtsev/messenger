//
//  ClassicTheme.swift
//  Messenger
//
//  Created by belotserkovtsev on 10.03.2021.
//

import UIKit

class ClassicTheme: ThemeProtocol {
	
	var navigationBarStyle: UIBarStyle = .default
	
	var navigationBarTextColor: UIColor = .black
	
	var navigationBarTint: UIColor = .white
	
	var mainViewsBackgroundColor: UIColor = .white
	
	var mainFontsColor: UIColor = .black
	
	var mainButtonsBackgroundColor: UIColor = .lightButton
	
	var conversationsListUITableViewSeparatorColor: UIColor? = nil
	
	var conversationsListUITableViewBackgroundColor: UIColor = .init(white: 0.97, alpha: 1)
	
	var conversationsListSelectedCellView: UIView? = nil
	
	var conversationsListCellBackgroundColor: UIColor = .white
	
	var conversationUITableViewBackgroundColor: UIColor? = nil
	
	var conversationCellBackgroundColor: UIColor? = nil
	
	var conversationCellIncomingBubbleBackgroundColor: UIColor = .classicIncomingBubble
	
	var conversationCellOutgoingBubbleBackgroundColor: UIColor = .classicOutgoingBubble
	
	var conversationCellIncomingBubbleTextColor: UIColor = .black
	
	var conversationCellOutgoingBubbleTextColor: UIColor = .black
	
}
