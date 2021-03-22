//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 28.02.2021.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView?
	private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
	private lazy var database = Firestore.firestore()
	private lazy var reference = database.collection("channels")
	private var channelsModel = ChannelDataModel()
	
	//MARK: Nav Bar Tap Handlers
	@objc private func profileTapHandler() {
		let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
		let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
		if let profileViewController = profile {
			navigationController?.pushViewController(profileViewController, animated: true)
		}
	}
	
	@objc private func settingsTapHandler() {
		let storyBoard = UIStoryboard(name: "Themes", bundle: nil)
		let theme = storyBoard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController
		if let themeViewController = theme {
			navigationController?.pushViewController(themeViewController, animated: true)
		}
	}
	
	//MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView?.delegate = self
		
		title = "Channels"
		setTrailingBarButtonItem()
		setLeadingBarButtonItem()
		
		tableView?.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		tableView?.rowHeight = 88
		
		tableView?.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
		
		reference.addSnapshotListener { [weak self] snapshot, error in
			guard let documents = snapshot?.documents else { return }
			var channels = [ChannelDataModel.Channel]()
			for document in documents {
				let documentData = document.data()
				let id = document.documentID
				if let name = documentData["name"] as? String, !name.isEmpty {
					
					let timestamp = documentData["lastActivity"] as? Timestamp
					let lastMessage = documentData["lastMessage"] as? String
					
					let data = ChannelDataModel.Channel.init(id: id,
															 name: name,
															 lastMessage: lastMessage,
															 lastActivity: timestamp?.dateValue(),
															 online: true,
															 hasUnreadMessages: false)
					channels.append(data)
				}
				self?.channelsModel.reload(with: channels)
				self?.tableView?.reloadData()
				
			}
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		switch ThemeManager.currentTheme {
		case .night:
			tableView?.backgroundColor = .black
		default:
			tableView?.backgroundColor = UIColor(white: 0.97, alpha: 1)
		}
	}
	
	//MARK: UI Modifiers
	private func setTrailingBarButtonItem() {
		if let profileItemImage = UIImage(named: "Profile"),
		   let resizedProfileItemImage = resizeImage(image: profileItemImage, targetSize: CGSize(width: 22, height: 22))  {
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizedProfileItemImage, style: .plain, target: self, action: #selector(profileTapHandler))
			navigationItem.rightBarButtonItem?.tintColor = .gray
		} else {
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileTapHandler))
		}
	}
	
	private func setLeadingBarButtonItem() {
		if let settingsItemImage = UIImage(named: "Settings"),
		   let resizedSettingsItemImage = resizeImage(image: settingsItemImage, targetSize: CGSize(width: 22, height: 22))  {
			navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedSettingsItemImage, style: .plain, target: self, action: #selector(settingsTapHandler))
			navigationItem.leftBarButtonItem?.tintColor = .gray
		} else {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapHandler))
		}
	}
	
	private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
		let size = image.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
}

//MARK: Data
extension ConversationsListViewController {
	struct ChannelDataModel {
		private(set) var channels = [Channel]()
		
		mutating func reload(with channels: [Channel]) {
			self.channels = channels.sorted { left, right in
				guard let leftLatestActivity = left.lastActivity else { return false }
				guard let rigtLatestActivity = right.lastActivity else { return true }
				return leftLatestActivity > rigtLatestActivity
			}
		}
		
		struct Channel {
			var id: String
			var name: String
			var lastMessage: String?
			var lastActivity: Date?
			var online: Bool
			var hasUnreadMessages: Bool
		}
	}
}

//MARK: UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		channelsModel.channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = channelsModel.channels[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationsListTableViewCell else { return UITableViewCell() }
		cell.configure(with: data)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		1
	}
}

//MARK: UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
		let conversation = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
		
		conversation?.title = channelsModel.channels[indexPath.row].name
		conversation?.setId(with: channelsModel.channels[indexPath.row].id)
		
		if let conversationViewController = conversation {
			navigationController?.pushViewController(conversationViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			reference.document(channelsModel.channels[indexPath.row].id).delete()
		}
	}
}
