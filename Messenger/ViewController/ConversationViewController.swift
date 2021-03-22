//
//  ConversationViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 01.03.2021.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView?
	@IBOutlet weak var messageTextView: UITextView?
	
	private let cellIdentifier = String(describing: ConversationTableViewCell.self)
	
	private var channelId: String?
	private var channelModel = ConversationDataModel()
	
	private lazy var database = Firestore.firestore()
	private lazy var reference = database.collection("channels/\(channelId!)/messages")
	
	@IBAction func sendButtonHandler(_ sender: UIButton) {
		guard let text = messageTextView?.text.trimmingCharacters(in: .whitespacesAndNewlines),
			  !text.isEmpty, let id = UIDevice.current.identifierForVendor?.uuidString else {
			messageTextView?.text = ""
			return
		}
		
		reference.addDocument(data: ["content" : text, "created" : Timestamp(), "senderId" : id, "senderName" : "Bogdan"])
		messageTextView?.text = ""
	}
	
	
	//MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		messageTextView?.layer.cornerRadius = 12
		messageTextView?.layer.borderWidth = 1
		messageTextView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		tableView?.estimatedRowHeight = 10
		tableView?.rowHeight = UITableView.automaticDimension
		
		tableView?.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		
		tableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
		
		reference.addSnapshotListener { [weak self] snapshot, error in
			guard let documents = snapshot?.documents else { return }
			var messages = [ConversationDataModel.Message]()
			for document in documents {
				
				if let content = document["content"] as? String, let created = document["created"] as? Timestamp,
				   let senderId = document["senderId"] as? String, let senderName = document["senderName"] as? String {
					
					let isOutgoing = senderId == UIDevice.current.identifierForVendor?.uuidString
					
					messages.append(.init(text: content, created: created.dateValue(), senderId: senderId, senderName: senderName, messageType: isOutgoing ? .outgoing : .incoming))
				}
				
			}
			self?.channelModel.reload(with: messages)
			self?.tableView?.reloadData()
		}
	}
	
	func setId(with id: String) {
		channelId = id
	}
	
	//MARK: Data
	struct ConversationDataModel {
		private(set) var messages = [Message]()
		
		mutating func reload(with data: [Message]) {
			messages = data.sorted { $0.created < $1.created }
		}
		
		struct Message {
			var text: String
			var created: Date
			var senderId: String
			var senderName: String
			
			var messageType: MessageType
		}
		
		enum MessageType {
			case incoming, outgoing
		}
	}
}

//MARK: UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		channelModel.messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let data = channelModel.messages[channelModel.messages.count - indexPath.row - 1]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationTableViewCell else { return UITableViewCell() }
		cell.configure(with: data)
		cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
		return cell
	}
}
