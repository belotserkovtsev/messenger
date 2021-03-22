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
	
	func save(data: ProfileDataModel, isFirstLaunch: Bool = false, completion: @escaping (ProfileDataCompletionStatus) -> ()) {
		writeWorkItem = DispatchWorkItem {
			do {
				let userDataFileURL = try self.getUrl(for: "ProfileData", dot: "json")
				let imageDataFileURL = try self.getUrl(for: "ProfileImage", dot: "png")
				
				let storableData: ProfileDataStorable = .init(name: data.name, description: data.description)
				
				let jsonData = try JSONEncoder().encode(storableData)
				let imageData = data.profilePicture?.jpegData(compressionQuality: 1)
				
				if isFirstLaunch {
					let profileDataBackupURL = try self.getUrl(for: "ProfileDataBackup", dot: "json")
					try jsonData.write(to: profileDataBackupURL)
				}
				
				sleep(3)
				
				try jsonData.write(to: userDataFileURL)
				try imageData?.write(to: imageDataFileURL)
				
				
				if let isCancelled = self.writeWorkItem?.isCancelled {
					if isCancelled {
						DispatchQueue.main.async {
							completion(.cancelled)
						}
						self.writeWorkItem = nil
						self.restoreFromBackup()
					} else {
						let backupDataURL = try self.getUrl(for: "ProfileDataBackup", dot: "json")
						let backupImageURL = try self.getUrl(for: "ProfileImageBackup", dot: "png")
						
						let jsonBackupData = jsonData
						try jsonBackupData.write(to: backupDataURL)
						
						let backupImageData = imageData
						try backupImageData?.write(to: backupImageURL)
						
						DispatchQueue.main.async {
							completion(.success(data: nil))
						}
					}
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
				
				let storableData = try JSONDecoder().decode(ProfileDataStorable.self, from: text ?? Data())
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
	
	//MARK: Private methods
	
	private func restoreFromBackup() {
		do {
			let backupDataURL = try getUrl(for: "ProfileDataBackup", dot: "json")
			let backupImageURL = try getUrl(for: "ProfileImageBackup", dot: "png")
			
			let imageURL = try getUrl(for: "ProfileImage", dot: "png")
			let dataURL = try getUrl(for: "ProfileData", dot: "json")
			
			let profileData = try String(contentsOf: backupDataURL, encoding: .utf8).data(using: .utf8)
			
			let image = UIImage(contentsOfFile: backupImageURL.path)
			let imageData = image?.jpegData(compressionQuality: 1)
			
			try profileData?.write(to: dataURL)
			
			if let data = imageData {
				try data.write(to: imageURL)
			} else {
				try FileManager().removeItem(at: imageURL)
			}
			
			
		} catch {
			print("error with writing/reading to/from backup")
		}
		
	}
	
	private func getUrl(for fileName: String, dot fileExtension: String) throws -> URL {
		let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
		return fileURL
	}
}
