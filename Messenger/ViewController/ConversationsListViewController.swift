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
	private var firestoreManager = FirestoreManager(path: "channels")
	private var channelsModel = ChannelModel()
	
	// MARK: Nav Bar Tap Handlers
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
	
	@objc private func addConversationTapHandler() {
		showInputDialog(title: "Add channel",
						subtitle: "Please enter a name of the channel you want to create.",
						actionTitle: "Create",
						cancelTitle: "Cancel",
						inputPlaceholder: "Channel name",
						inputKeyboardType: .default) { input in
			
			guard let channelName = input else {
				let errorAlert = UIAlertController(title: "Error", message: "Unable to create channel with no name", preferredStyle: .alert)
				errorAlert.addAction(.init(title: "Ok", style: .cancel))
				self.present(errorAlert, animated: true)
				return
			}
			
			self.firestoreManager.addDocumnent(data: ["name": channelName])
		}
	}
	
	// MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView?.delegate = self
		
		title = "Channels"
		setTrailingBarButtonItem()
		setLeadingBarButtonItems()
		
		tableView?.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		tableView?.rowHeight = 88
		
		tableView?.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
		
		firestoreManager.addListener { [weak self] snapshot, _ in
			DispatchQueue.global(qos: .userInitiated).async {
				guard let documents = snapshot?.documents else { return }
				var channels = [ChannelModel.Channel]()
				for document in documents {
					let documentData = document.data()
					let id = document.documentID
					if let name = documentData["name"] as? String, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
						
						let timestamp = documentData["lastActivity"] as? Timestamp
						let lastMessage = documentData["lastMessage"] as? String
						let hasRecentlyBeenActive = self?.hasRecentlyBeenActive(for: timestamp?.dateValue()) ?? false
						
						let data = ChannelModel.Channel(id: id,
														name: name,
														lastMessage: lastMessage,
														lastActivity: timestamp?.dateValue(),
														online: hasRecentlyBeenActive,
														hasUnreadMessages: false)
						channels.append(data)
					}
				}
			
				DispatchQueue.main.async {
					self?.channelsModel.reload(with: channels)
					self?.tableView?.reloadData()
				}
				
				CoreDataStack().performSave { context in
					channels.forEach { channel in
						_ = ChannelDB(for: channel, in: context)
					}
				}
			}
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		switch ThemeManager.currentTheme {
		case .night:
			tableView?.backgroundColor = .black
		default:
			tableView?.backgroundColor = UIColor(white: 0.97, alpha: 1)
		}
	}
	// MARK: UI Modifiers/Private methods
	private func hasRecentlyBeenActive(for date: Date?) -> Bool {
		guard let inputDate = date else { return false }
		
		let calendar = Calendar.current
		let startOfNow = Date()
		let startOfTimeStamp = inputDate
		
		let components = calendar.dateComponents([.minute], from: startOfNow, to: startOfTimeStamp)
		let minuteComponent = components.minute
		if let minute = minuteComponent {
			if abs(minute) >= 10 {
				return false
			} else {
				return true
			}
		}
		return false
	}
	
	private func setTrailingBarButtonItem() {
		if let profileItemImage = UIImage(named: "Plus"),
		   let resizedProfileItemImage = resizeImage(image: profileItemImage, targetSize: CGSize(width: 22, height: 22)) {
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizedProfileItemImage, style: .plain, target: self, action: #selector(addConversationTapHandler))
			navigationItem.rightBarButtonItem?.tintColor = .gray
		} else {
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addConversationTapHandler))
		}
	}
	
	private func setLeadingBarButtonItems() {
		var profile = UIBarButtonItem()
		var settings = UIBarButtonItem()
		
		if let settingsItemImage = UIImage(named: "Settings"),
		   let resizedSettingsItemImage = resizeImage(image: settingsItemImage, targetSize: CGSize(width: 22, height: 22)) {
			settings = UIBarButtonItem(image: resizedSettingsItemImage, style: .plain, target: self, action: #selector(settingsTapHandler))
			settings.tintColor = .gray
		} else {
			settings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapHandler))
		}
		
		if let profileItemImage = UIImage(named: "Profile"),
		   let resizedProfileItemImage = resizeImage(image: profileItemImage, targetSize: CGSize(width: 22, height: 22)) {
			profile = UIBarButtonItem(image: resizedProfileItemImage, style: .plain, target: self, action: #selector(profileTapHandler))
			profile.tintColor = .gray
		} else {
			profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileTapHandler))
		}
		
		navigationItem.leftBarButtonItems = [settings, profile]
	}
	
	private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
		let size = image.size
		
		let widthRatio  = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if widthRatio > heightRatio {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
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

// MARK: UITableViewDataSource
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

// MARK: UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard: UIStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
		let conversation = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
		
		conversation?.title = channelsModel.channels[indexPath.row].name
		conversation?.setChannelData(with: channelsModel.channels[indexPath.row])
		
		if let conversationViewController = conversation {
			navigationController?.pushViewController(conversationViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			firestoreManager.deleteDocument(id: channelsModel.channels[indexPath.row].id)
		}
	}
}
