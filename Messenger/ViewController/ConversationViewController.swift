//
//  ConversationViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 01.03.2021.
//

import UIKit

class ConversationViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView?
	
	private let cellIdentifier = String(describing: ConversationTableViewCell.self)
	
	//MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView?.estimatedRowHeight = 10
		tableView?.rowHeight = UITableView.automaticDimension
		
		tableView?.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
		tableView?.dataSource = self
		
		tableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
	}
	
	//MARK: Data
	struct ConversationDataModel {
		var messages: [Message]
		
		struct Message {
			var text: String?
			var messageType: MessageType
		}
		
		enum MessageType {
			case incoming, outgoing
		}
	}
	
	private var conversationData =
		ConversationDataModel(messages:
				[.init(text: "Hey!", messageType: .incoming),
				 .init(text: nil, messageType: .outgoing),
				 .init(text: "Wassup", messageType: .incoming),
				 .init(text: "Nm hbu? Justo habitasse in ornare tortor, vestibulum aenean integer mattis orci, nisi quis, lectus nec non ultricies. Tortor, vitae in dictum.", messageType: .outgoing),
				 .init(text: "Justo habitasse in ornare tortor, vestibulum aenean integer mattis orci, nisi quis", messageType: .outgoing),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .incoming),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .outgoing),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .incoming),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .incoming),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .incoming),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .incoming),
				 .init(text: "Id quis, vitae tortor, nisi ipsum mauris et eleifend dolor nec tortor, arcu platea libero, mollis nunc ornare eget et. Ornare et arcu platea habitasse libero, hac orci, nunc quis.", messageType: .outgoing)])
	
}

//MARK: UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		conversationData.messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//		let section = conversationData[indexPath.section]
		let data = conversationData.messages[conversationData.messages.count - indexPath.row - 1]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
				as? ConversationTableViewCell else { return UITableViewCell() }
		cell.configure(with: data)
		cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
		return cell
	}
}
