//
//  IFirestoreService.swift
//  Messenger
//
//  Created by belotserkovtsev on 13.04.2021.
//

import Foundation
import Firebase

protocol IFirestoreService {
	init(path: String)
	init(path: String, listener: @escaping (QuerySnapshot?, Error?) -> Void)
	
	func addListener(listener: @escaping (QuerySnapshot?, Error?) -> Void)
	func addDocumnent(data: [String: Any])
	func deleteDocument(id: String)
}
