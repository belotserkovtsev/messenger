//
//  NightTheme.swift
//  Messenger
//
//  Created by belotserkovtsev on 08.03.2021.
//

import UIKit

class NightTheme: ThemeProtocol {
	
	var navigationBarStyle: UIBarStyle = .black
	
	var navigationBarTextColor: UIColor = .white
	
	var navigationBarTint: UIColor = .black
	
	var mainViewsBackgroundColor: UIColor = .black
	
	var mainFontsColor: UIColor = .white
	
	var mainButtonsBackgroundColor: UIColor = .nightButton
	
	var conversationsListUITableViewSeparatorColor: UIColor? = .nightSeparator
	
	var conversationsListSelectedCellView: UIView? {
		let selectedCellView = UIView()
		selectedCellView.backgroundColor = .nightSelectedCell
		return selectedCellView
	}
	
	var conversationsListCellBackgroundColor: UIColor = .black
	var conversationsListUITableViewBackgroundColor: UIColor = .black
	
//	var conversationsListUITableViewHeaderFooterView: UIView? {
//		let headerView = UIView()
//		headerView.backgroundColor = .black
//		return headerView
//	}
	
	var conversationUITableViewBackgroundColor: UIColor? = .black
	var conversationCellBackgroundColor: UIColor? = .black
	
	var conversationCellIncomingBubbleBackgroundColor: UIColor = .nightIncomingBubble
	
	var conversationCellOutgoingBubbleBackgroundColor: UIColor = .nightOutgoingBubble
	
	var conversationCellIncomingBubbleTextColor: UIColor = .white
	
	var conversationCellOutgoingBubbleTextColor: UIColor = .white
}
