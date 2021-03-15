//
//  GCDManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import UIKit

class GCDManager {
	func save(data: ProfileData, image: UIImage?, completion: @escaping (CompletionStatus) -> ()) {
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				let userDataFileURL = try self.getUrl(for: "ProfileData", dot: "json")
				let imageDataFileURL = try self.getUrl(for: "ProfileImage", dot: "png")
				
				let imageData = image?.jpegData(compressionQuality: 1)
				let jsonData = try JSONEncoder().encode(data)
				sleep(5)
				try jsonData.write(to: userDataFileURL)
				try imageData?.write(to: imageDataFileURL)
				
				DispatchQueue.main.async {
					completion(.success)
				}
			} catch {
				DispatchQueue.main.async {
					completion(.failure(error: .init(id: 1)))
				}
			}
		}
	}
	
	func get() throws -> (ProfileData, UIImage?) {
		let fileURL = try getUrl(for: "ProfileData", dot: "json")
		let text = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)
		let obj = try JSONDecoder().decode(ProfileData.self, from: text!)
		
		let imageUrl = try getUrl(for: "ProfileImage", dot: "png")
		let image = UIImage(contentsOfFile: imageUrl.path)
//		sleep(5)
		return (obj, image)
	}
	
	private func getUrl(for fileName: String, dot fileExtension: String) throws -> URL {
		let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
		return fileURL
	}
}
