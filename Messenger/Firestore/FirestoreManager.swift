//
//  FirestoreManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 24.03.2021.
//

import Foundation
import Firebase

class FirestoreManager {
	private var path: String
	private var snapshotListener: ListenerRegistration?
	private lazy var database = Firestore.firestore()
	private lazy var reference = database.collection(path)
	
	init(path: String) {
		self.path = path
	}
	
	init(path: String, listener: @escaping (QuerySnapshot?, Error?) -> Void) {
		self.path = path
		snapshotListener = reference.addSnapshotListener(listener)
	}
	
	func addListener(listener: @escaping (QuerySnapshot?, Error?) -> Void) {
		snapshotListener = reference.addSnapshotListener(listener)
	}
	
	func addDocumnent(data: [String: Any]) {
		reference.addDocument(data: data)
	}
	
	func deleteDocument(id: String) {
		reference.document(id).delete()
	}
	
	deinit {
		snapshotListener?.remove()
	}
}
