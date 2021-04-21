//
//  NetworkStack.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import Foundation

class NetworkTask: INetworkTask {
	var tasks = [URLSessionTask]()
	let session = URLSession.shared
	
	func get<T: Decodable>(url: URL, headers: [String: String]?, completion: ((Result<T, NetworkError>) -> Void)?) {
		var request = URLRequest(url: url, timeoutInterval: 5)
		request.allHTTPHeaderFields = headers
		let task = session.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: nil)))
				}
				return
			}
			let status = httpResponse.statusCode
			if error != nil {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: status)))
				}
			}
			guard let data = data else {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: status)))
				}
				return
			}
			do {
				let responseData = try JSONDecoder().decode(T.self, from: data)
				DispatchQueue.main.async {
					completion?(.success(responseData))
				}
			} catch {
				DispatchQueue.main.async {
					completion?(.failure(.decodingFailure))
				}
			}
		}
		
		task.resume()
		tasks.append(task)
	}
	
	func get(url: URL, headers: [String: String]?, completion: ((Result<Data, NetworkError>) -> Void)?) {
		var request = URLRequest(url: url, timeoutInterval: 5)
		request.allHTTPHeaderFields = headers
		let task = session.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: nil)))
				}
				return
			}
			let status = httpResponse.statusCode
			if error != nil {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: status)))
				}
			}
			guard let data = data else {
				DispatchQueue.main.async {
					completion?(.failure(.serverFailure(statusCode: status)))
				}
				return
			}
			sleep(1)
			DispatchQueue.main.async {
				completion?(.success(data))
			}
		}
		
		task.resume()
		tasks.append(task)
	}
	
	func cancel() {
		for task in tasks {
			task.cancel()
		}
		session.invalidateAndCancel()
	}
	
	deinit {
		cancel()
	}
}
