//
//  INetworkTask.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import Foundation

protocol INetworkTask {
	func get<T: Decodable>(url: URL, headers: [String: String]?, completion: ((Result<T, NetworkError>) -> Void)?)
	func get(url: URL, headers: [String: String]?, completion: ((Result<Data, NetworkError>) -> Void)?)
	func cancel()
}
