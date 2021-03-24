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
	@IBOutlet weak var messageTextViewWrapperView: UIView?
	@IBOutlet weak var sendBarView: ThemeDependentUIView?
	@IBOutlet weak var messageTextViewPlaceholderLabel: UILabel?
	@IBOutlet weak var sendButton: UIButton?
	
	private let cellIdentifier = String(describing: ConversationTableViewCell.self)
	
	private var channelId: String?
	private var cachedName: String?
	private var channelModel = ConversationDataModel()
	
	private lazy var database = Firestore.firestore()
	private lazy var reference = database.collection("channels/\(channelId ?? " ")/messages")
	
	@IBAction func sendButtonHandler(_ sender: UIButton) {
		guard let text = messageTextView?.text.trimmingCharacters(in: .whitespacesAndNewlines),
			  !text.isEmpty, let id = UIDevice.current.identifierForVendor?.uuidString else {
			messageTextView?.text = ""
			return
		}
		
		if let profileName = cachedName {
			self.messageTextView?.text = ""
			reference.addDocument(data: ["content": text, "created": Timestamp(), "senderId": id, "senderName": profileName])
		} else {
			GCDManager().get { result in
				switch result {
				case .success(let data):
					guard let profileName = data?.name else { break }
					self.messageTextView?.text = ""
					self.cachedName = profileName
					self.reference.addDocument(data: ["content": text, "created": Timestamp(), "senderId": id, "senderName": profileName])
				default:
					break
				}
			}
		}
	}
	
	// MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		messageTextViewWrapperView?.layer.cornerRadius = 12
		messageTextViewWrapperView?.layer.borderWidth = 1
		messageTextViewWrapperView?.layer.borderColor = UIColor.themeBorder.cgColor
		
		tableView?.estimatedRowHeight = 10
		tableView?.rowHeight = UITableView.automaticDimension
		
		tableView?.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		
		tableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
		
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		let gesture = self.hideKeyboardWhenTappedAround()
		gesture.delegate = self
		
		reference.addSnapshotListener { [weak self] snapshot, _ in
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
		
		messageTextView?.delegate = self
	}
	
	func setId(with id: String) {
		channelId = id
	}
	
	// MARK: Data
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

// MARK: UITableViewDataSource
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

// MARK: OBJC andlers
extension ConversationViewController {
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	@objc private func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
}

// MARK: TextView Delegate
extension ConversationViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if let placeholder = messageTextViewPlaceholderLabel {
			if textView.text.count > 0 && !placeholder.isHidden {
				placeholder.isHidden = true
			} else if textView.text.count == 0 && placeholder.isHidden {
				placeholder.isHidden = false
			}
		}
		
		if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
			sendButton?.isEnabled = true
		} else {
			sendButton?.isEnabled = false
		}
		
		if textView.contentSize.height > 100 && !textView.isScrollEnabled {
			let frame = textView.frame
			textView.isScrollEnabled = true
			let heightConstraint: NSLayoutConstraint =
				.init(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height)
			heightConstraint.identifier = "height"
			textView.addConstraint(heightConstraint)
		}
		
		if textView.contentSize.height < 100 && textView.isScrollEnabled {
			let heightConstraint = textView.constraints.first { constraint in
				constraint.identifier == "height"
			}
			heightConstraint?.constant = textView.contentSize.height
			textView.isScrollEnabled = false
		}
		
		if textView.contentSize.height < 100 && !textView.isScrollEnabled {
			textView.sizeToFit()
			let heightConstraint = textView.constraints.first { constraint in
				constraint.identifier == "height"
			}
			heightConstraint?.constant = textView.contentSize.height
		}
	}
}

// MARK: UIGestureRecognizerDelegate
extension ConversationViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		guard let tableView = self.tableView else { return false }
		return touch.view?.isDescendant(of: tableView) == true
	}
}
