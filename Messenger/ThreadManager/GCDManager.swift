//
//  GCDManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import UIKit

class GCDManager {
	
	private var writeWorkItem: DispatchWorkItem?
	private var readWorkItem: DispatchWorkItem?
	
	func cancel(_ type: WorkItemType) {
		switch type {
		case .read:
			self.readWorkItem?.cancel()
		case .write:
			self.writeWorkItem?.cancel()
		}
	}
	
	func save(data: ProfileDataModel, completion: @escaping (ProfileDataCompletionStatus) -> ()) {
		writeWorkItem = DispatchWorkItem {
			do {
				let userDataFileURL = try self.getUrl(for: "ProfileData", dot: "json")
				let imageDataFileURL = try self.getUrl(for: "ProfileImage", dot: "png")
				
				let storableData: ProfileDataStorable = .init(name: data.name, description: data.description)
				
				let jsonData = try JSONEncoder().encode(storableData)
				let imageData = data.profilePicture?.jpegData(compressionQuality: 1)
				
				sleep(3)
				if let isCancelled = self.writeWorkItem?.isCancelled, isCancelled {
					DispatchQueue.main.async {
						completion(.cancelled)
					}
					self.writeWorkItem = nil
					return
				}
				try jsonData.write(to: userDataFileURL)
				try imageData?.write(to: imageDataFileURL)
				
				DispatchQueue.main.async {
					completion(.success(data: nil))
				}
				self.writeWorkItem = nil
			} catch {
				DispatchQueue.main.async {
					completion(.failure(error: .init(id: 1)))
				}
				self.writeWorkItem = nil
			}
		}
		if let item = writeWorkItem {
			DispatchQueue.global(qos: .userInitiated).async(execute: item)
		}
	}
	
	func get(completion: @escaping (ProfileDataCompletionStatus) -> ()) {
		readWorkItem = DispatchWorkItem {
			do {
				let fileURL = try self.getUrl(for: "ProfileData", dot: "json")
				let imageUrl = try self.getUrl(for: "ProfileImage", dot: "png")
				
				if let isCancelled = self.readWorkItem?.isCancelled, isCancelled {
					DispatchQueue.main.async {
						completion(.cancelled)
					}
					self.readWorkItem = nil
					return
				}
				let text = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)
				let image = UIImage(contentsOfFile: imageUrl.path)
				
				let storableData = try JSONDecoder().decode(ProfileDataStorable.self, from: text!)
				let presentableData: ProfileDataModel = .init(name: storableData.name, description: storableData.description, profilePicture: image)
				
				DispatchQueue.main.async {
					completion(.success(data: presentableData))
				}
				self.readWorkItem = nil
			} catch {
				DispatchQueue.main.async {
					completion(.failure(error: .init(id: 1)))
				}
				self.readWorkItem = nil
			}
		}
		if let item = readWorkItem {
			DispatchQueue.global(qos: .userInitiated).async(execute: item)
		}
		
	}
	
	private func getUrl(for fileName: String, dot fileExtension: String) throws -> URL {
		let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
		return fileURL
	}
	
	enum WorkItemType {
		case write, read
	}
}
