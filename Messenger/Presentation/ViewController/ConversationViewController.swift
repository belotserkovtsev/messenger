//
//  ConversationViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 01.03.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var messageTextViewWrapperView: UIView!
	@IBOutlet weak var sendBarView: ThemeDependentUIView!
	@IBOutlet weak var messageTextViewPlaceholderLabel: UILabel!
	@IBOutlet weak var sendButton: UIButton!
	
	private let cellIdentifier = String(describing: ConversationTableViewCell.self)
	private var cachedProfileName: String?
	
	var backendService: IFirestoreService?
	var persistenceService: IPersistenceConversationService?
	private var conversationModel = ConversationModel()
	
	// MARK: Gestures
	@IBAction func sendButtonHandler(_ sender: UIButton) {
		sendMessage()
	}
	
	// MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		messageTextViewWrapperView.layer.cornerRadius = 12
		messageTextViewWrapperView.layer.borderWidth = 1
		messageTextViewWrapperView.layer.borderColor = UIColor.themeBorder.cgColor
		
		tableView.estimatedRowHeight = 10
		tableView.rowHeight = UITableView.automaticDimension
		
		persistenceService?.fetch()
		
		tableView.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView.dataSource = self
		
		tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
		
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		let gesture = self.hideKeyboardWhenTappedAround()
		gesture.delegate = self
		
		if #available(iOS 13.0, *) {
			let interaction = UIContextMenuInteraction(delegate: self)
			sendButton.addInteraction(interaction)
		}
		
		messageTextView.delegate = self
	}
}

// MARK: UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = persistenceService?.sections else { fatalError("no sections found") }
		let sectionsInfo = sections[section]
		return sectionsInfo.numberOfObjects
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationTableViewCell, let data = persistenceService?.object(at: indexPath) as? MessageDB else { return UITableViewCell() }
		let configurableCell = ConversationModel.Message(for: data)
		cell.configure(with: configurableCell)
		cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
		return cell
	}
}

// MARK: FetchResultsController Delegate
extension ConversationViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		print("begin update")
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		print("end update")
		tableView.endUpdates()
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			if let newIndexPath = newIndexPath {
				print("inserting")
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		case .move:
			if let newIndexPath = newIndexPath, let indexPath = indexPath {
				print("moving")
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		case .update:
			if let indexPath = indexPath {
				print("updating")
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		case .delete:
			if let indexPath = indexPath {
				print("deleting")
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
		default:
			break
		}
	}
}

// MARK: OBJC andlers
extension ConversationViewController {
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if additionalSafeAreaInsets.bottom == 0 {
				UIView.animate(withDuration: 1) {
					self.additionalSafeAreaInsets.bottom += keyboardSize.height
					self.view.layoutIfNeeded()
				}
				
			}
			
		}
	}
	
	@objc private func keyboardWillHide(notification: NSNotification) {
		if additionalSafeAreaInsets.bottom != 0 {
			UIView.animate(withDuration: 1) {
				self.additionalSafeAreaInsets.bottom = 0
				self.view.layoutIfNeeded()
			}
		}
	}
}

// MARK: Private Methods
extension ConversationViewController {
	private func sendMessage(anonymously isAnonymous: Bool = false) {
		let text = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !text.isEmpty, let id = UIDevice.current.identifierForVendor?.uuidString else {
			messageTextView.text = ""
			return
		}
		
		if let profileName = cachedProfileName {
			clearTextField()
			backendService?.addDocumnent(data: ["content": text, "created": Timestamp(), "senderId": id, "senderName": isAnonymous ? "Anonymous" : profileName])
		} else {
			GCDManager().get { result in
				switch result {
				case .success(let data):
					guard let profileName = data?.name else { break }
					self.clearTextField()
					self.cachedProfileName = profileName
					self.backendService?.addDocumnent(data: ["content": text, "created": Timestamp(), "senderId": id, "senderName": isAnonymous ? "Anonymous" : profileName])
				default:
					break
				}
			}
		}
	}
	
	private func clearTextField() {
		guard let textview = messageTextView, let sendButton = sendButton else { return }
		textview.text = ""
		sendButton.isEnabled = false
		textViewDidChange(textview)
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
			sendButton.isEnabled = true
		} else {
			sendButton.isEnabled = false
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
			removeTextViewHeightConstraint()
		}
	}
	
	private func removeTextViewHeightConstraint() {
		guard let textView = messageTextView else { return }
		guard let heightConstraint = textView.constraints.first(where: { $0.identifier == "height" }) else { return }
		textView.removeConstraint(heightConstraint)
	}
}

// MARK: UIGestureRecognizerDelegate
extension ConversationViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		guard let tableView = self.tableView else { return false }
		return touch.view?.isDescendant(of: tableView) == true
	}
}

@available(iOS 13.0, *)
extension ConversationViewController: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		
		let send = UIAction(title: "Send", image: UIImage(systemName: "paperplane")) { _ in
			self.sendMessage()
		}
		
		let sendAnon = UIAction(title: "Send anonymously", image: UIImage(systemName: "person.crop.circle.badge.questionmark")) { _ in
			self.sendMessage(anonymously: true)
		}
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
			UIMenu(title: "Send options", children: [send, sendAnon])
		}
	}
}

// MARK: Make
extension ConversationViewController {
	static func make(with id: String) -> ConversationViewController? {
		let storyBoard: UIStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
		guard let vc = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController else {
			return nil
		}
		
		let serviceAssembly = ServiceAssembly()
		
		vc.backendService = serviceAssembly.conversationBackendService(for: id)
		vc.persistenceService = serviceAssembly.conversationPersistenceService(id: id, delegate: vc)
		
		vc.backendService?.addListener { snapshot, _ in
			DispatchQueue.global(qos: .userInitiated).async {
				guard let documents = snapshot?.documents else { return }
				vc.conversationModel.clear()
				for document in documents {
					
					if let content = document["content"] as? String, let created = document["created"] as? Timestamp,
					   let senderId = document["senderId"] as? String, let senderName = document["senderName"] as? String,
					   !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
						
						let isOutgoing = senderId == UIDevice.current.identifierForVendor?.uuidString
						
						vc.conversationModel.append(message: .init(id: document.documentID, text: content,
											  created: created.dateValue(), senderId: senderId,
											  senderName: senderName, messageType: isOutgoing ? .outgoing : .incoming))
					}
					
				}
				
				vc.persistenceService?.performSave(messages: vc.conversationModel.messages)
			}
		}
		
		return vc
	}
}
