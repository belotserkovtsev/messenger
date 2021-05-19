//
//  Vcs+make.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit
import Firebase

extension ProfileViewController {
	static func make() -> ProfileViewController? {
		let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
		guard let vc = storyBoard.instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else {
			return nil
		}
		
		let serviceAssembly = ServiceAssembly()
		vc.fileService = serviceAssembly.profileFileService
		
		return vc
	}
}

extension ConversationsListViewController {
	static func make() -> ConversationsListViewController? {
		let storyBoard: UIStoryboard = UIStoryboard(name: "ConversationsList", bundle: nil)
		guard let vc = storyBoard.instantiateViewController(withIdentifier: "ConversationsList") as? ConversationsListViewController else {
			return nil
		}
		
		let serviceAssembly = ServiceAssembly()
		vc.backendService = serviceAssembly.conversationsBackendService
		
		let persistenceService = serviceAssembly.conversationsPersistenceService(delegate: vc)
		vc.persistenceService = persistenceService
		
		vc.backendService?.addListener { snapshot, _ in
			DispatchQueue.global(qos: .userInitiated).async {
				guard let documents = snapshot?.documents else { return }
				vc.channelsModel.clear()
				for document in documents {
					let documentData = document.data()
					let id = document.documentID
					if let name = documentData["name"] as? String, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
						
						let timestamp = documentData["lastActivity"] as? Timestamp
						let lastMessage = documentData["lastMessage"] as? String
						let hasRecentlyBeenActive = timestamp?.dateValue().hasPassedSinceNow(for: .minute, duration: 10) ?? false
						
						let data = ChannelModel.Channel(id: id,
														name: name,
														lastMessage: lastMessage,
														lastActivity: timestamp?.dateValue(),
														online: hasRecentlyBeenActive,
														hasUnreadMessages: false)
						vc.channelsModel.append(channel: data)
					}
				}
				
				vc.persistenceService?.performSave(data: vc.channelsModel.channels)
			}
		}
		
		return vc
	}
}

extension ImageSelectionViewController {
	static func make(avatarService: IAvatarService? = nil) -> ImageSelectionViewController? {
		let storyboard = UIStoryboard(name: "ImageSelection", bundle: nil)
		guard let vc = storyboard.instantiateViewController(withIdentifier: "ImageSelection") as? ImageSelectionViewController else { return nil }
		
		if let avatarService = avatarService {
			vc.avatarService = avatarService
		} else {
			let serviceAssmbly = ServiceAssembly()
			vc.avatarService = serviceAssmbly.avatarService
		}
		
		vc.avatarService?.getAvatars(count: { [weak vc] in
			vc?.dataModel.willLoad(count: $0)
			vc?.activityIndicator?.stopAnimating()
			vc?.collectionView?.reloadData()
		}, completion: { [weak vc] result in
			switch result {
			case .success(let (image, index)):
				vc?.dataModel.update(with: image, at: index)
				vc?.collectionView?.reloadData()
			case .failure(let err):
				vc?.handle(error: err)
			}
		})
		return vc
	}
}

extension AboutAppViewController {
	static func make(at index: Int) -> UIViewController? {
		let storyBoard: UIStoryboard = UIStoryboard(name: "AboutApp", bundle: nil)
		guard let vc = storyBoard.instantiateViewController(withIdentifier: "AboutApp") as? AboutAppViewController
		else { return nil }
		
		let presentationAssembly = PresentationAssembly()
		let serviceAssembly = ServiceAssembly()
		
		vc.initialSetupService = serviceAssembly.initialSetupService
		
		if index == 0 {
			vc.dataModel = presentationAssembly.onboardingDataSource[index]
			vc.index = index
			let navigationController = UINavigationController(rootViewController: vc)
			navigationController.setNavigationBarHidden(true, animated: false)
			return navigationController
		} else if index < presentationAssembly.onboardingDataSource.count {
			vc.dataModel = presentationAssembly.onboardingDataSource[index]
			vc.index = index
			return vc
		} else {
			return nil
		}
	}
}
