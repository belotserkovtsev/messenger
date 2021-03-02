//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 28.02.2021.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	struct ChatDataModel {
		var name: String?
		var message: String?
		var date: Date?
		var online: Bool
		var hasUnreadMessages: Bool
	}
	
	@IBOutlet weak var tableView: UITableView?
	private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
	
	//MARK: Table View Delegate Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		chatData[section].count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		chatData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = chatData[indexPath.section]
		let data = section[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationsListTableViewCell else { return UITableViewCell() }
		cell.configure(with: data)
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		section == 0 ? "Online" : "History"
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
		let conversation = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
		conversation?.title = chatData[indexPath.section][indexPath.row].name ?? "No name"
		if let conversationViewController = conversation {
			navigationController?.pushViewController(conversationViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: Nav Bar Tap Handlers
	@objc private func profileTapHandler() {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
		let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
		if let profileViewController = profile {
			present(profileViewController, animated: true, completion: nil)
		}
	}
	
	//MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView?.delegate = self
		
		title = "Tinkoff Chat"
		setBarButtonItem()
		
		tableView?.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		tableView?.rowHeight = 88
	}
	
	//MARK: UI Modifiers
	private func setBarButtonItem() {
		if let profileItemImage = UIImage(named: "Profile"),
		   let resizedProfileItemImage = resizeImage(image: profileItemImage, targetSize: CGSize(width: 22, height: 22))  {
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: resizedProfileItemImage, style: .plain, target: self, action: #selector(profileTapHandler))
			navigationItem.rightBarButtonItem?.tintColor = .gray
		} else {
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileTapHandler))
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
	
	//MARK: Data
	private var chatData: [[ChatDataModel]] =
		[[.init(name: "Egor Nosov", message: "What are you up to?", date: Date(), online: true, hasUnreadMessages: false),
		.init(name: "Alex Firsov", message: "I was trying to reach you but you were not ansering so i thought i would message you instead. Well, to be honest", date: Date(timeIntervalSinceNow: TimeInterval(-336_000)), online: true, hasUnreadMessages: false),
		.init(name: "Anastasia Bazueva", message: "Some bread, milk, youghurt and paper towels", date: Date(timeIntervalSinceNow: TimeInterval(-536_000)), online: true, hasUnreadMessages: true),
		.init(name: "Viktor", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: false),
		.init(name: "Mikhail Romanov", message: nil, date: nil, online: true, hasUnreadMessages: false),
		.init(name: "belotserkovtsev", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: false),
		.init(name: nil, message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: true),
		.init(name: "Andrey Bodrov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: true),
		.init(name: "Evgeniy Naumov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: false),
		.init(name: "Sasha Smirnov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: true, hasUnreadMessages: false)],
									   
	   [.init(name: "Egor Nosov", message: "What are you up to?", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Alex Firsov", message: "I was trying to reach you but you were not ansering so i thought i would message you", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Anastasia Bazueva", message: "Some bread, milk, youghurt and paper towels", date: Date(), online: false, hasUnreadMessages: true),
		.init(name: "Viktor Belfort", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Mikhail Romanov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Denver White", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Egor Nosov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Egor Nosov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Egor Nosov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false),
		.init(name: "Egor Nosov", message: "Amet enim do laborum tempor nisi aliqua ad adipisicing", date: Date(), online: false, hasUnreadMessages: false)]]
}
