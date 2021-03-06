//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 28.02.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	private let cellIdentifier = String(describing: ConversationsListTableViewCell.self)
	
	var backendService: IFirestoreService?
	var persistenceService: IPersistenceService?
	var channelsModel = ChannelModel()
	
	// MARK: Nav Bar Tap Handlers
	@objc private func profileTapHandler() {
		let profile = ProfileViewController.make()
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
			self.backendService?.addDocumnent(data: ["name": channelName])
		}
	}
	
	// MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		title = "Channels"
		setTrailingBarButtonItem()
		setLeadingBarButtonItems()
		
		tableView.register(UINib(nibName: String(describing: ConversationsListTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		
		tableView.rowHeight = 88
		tableView.contentInset = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
		
		persistenceService?.fetch()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let presentationAssembly = PresentationAssembly()
		switch presentationAssembly.currentTheme {
		case .night:
			tableView.backgroundColor = .black
		default:
			tableView.backgroundColor = UIColor(white: 0.97, alpha: 1)
		}
	}
	
	// MARK: UI Modifiers/Private methods
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
		guard let sections = persistenceService?.sections else { fatalError("no sections found") }
		let sectionsInfo = sections[section]
		return sectionsInfo.numberOfObjects
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let persistentObject = persistenceService?.object(at: indexPath)
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationsListTableViewCell, let data = persistentObject as? ChannelDB else { return UITableViewCell() }
		let configurableCell = ChannelModel.Channel(for: data)
		cell.configure(with: configurableCell)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		1
	}
}

// MARK: UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let channelManagedObject = persistenceService?.object(at: indexPath) as? ChannelDB else { return }
		let channel = ChannelModel.Channel(for: channelManagedObject)
		
		let conversation = ConversationViewController.make(with: channel.id)
		conversation?.title = channel.name
		
		if let conversationViewController = conversation {
			navigationController?.pushViewController(conversationViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let channelManagedObject = persistenceService?.object(at: indexPath) as? ChannelDB, let id = channelManagedObject.id {
				backendService?.deleteDocument(id: id)
			}
		}
	}
}

// MARK: FetchResultsController Delegate
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		print("begin update")
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		print("end update")
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
//				print("inserting")
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		case .move:
			if let newIndexPath = newIndexPath, let indexPath = indexPath {
//				print("moving")
				tableView.deleteRows(at: [indexPath], with: .automatic)
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		case .update:
			if let indexPath = indexPath {
//				print("updating")
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		case .delete:
			if let indexPath = indexPath {
//				print("deleting")
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
		default:
			break
		}
	}
}
