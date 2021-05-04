//
//  GCDManager.swift
//  Messenger
//
//  Created by belotserkovtsev on 15.03.2021.
//

import UIKit

class ProfileFileService: IProfileFileService {
	
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
	
	func write(data: ProfileModel, isFirstLaunch: Bool, completion: @escaping (ProfileDataCompletionStatus) -> Void) {
		writeWorkItem = DispatchWorkItem {
			do {
				let userDataFileURL = try self.url(for: "ProfileData", dot: "json")
				let imageDataFileURL = try self.url(for: "ProfileImage", dot: "png")
				
				let storableData: ProfileModelStorable = .init(name: data.name, description: data.description)
				
				let jsonData = try JSONEncoder().encode(storableData)
				let imageData = data.profilePicture?.jpegData(compressionQuality: 1)
				
				if isFirstLaunch {
					let profileDataBackupURL = try self.url(for: "ProfileDataBackup", dot: "json")
					try jsonData.write(to: profileDataBackupURL)
				}
				
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
						let backupDataURL = try self.url(for: "ProfileDataBackup", dot: "json")
						let backupImageURL = try self.url(for: "ProfileImageBackup", dot: "png")
						
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
	
	func read(completion: @escaping (ProfileDataCompletionStatus) -> Void) {
		readWorkItem = DispatchWorkItem {
			do {
				let fileURL = try self.url(for: "ProfileData", dot: "json")
				let imageUrl = try self.url(for: "ProfileImage", dot: "png")
				
				if let isCancelled = self.readWorkItem?.isCancelled, isCancelled {
					DispatchQueue.main.async {
						completion(.cancelled)
					}
					self.readWorkItem = nil
					return
				}
				let text = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)
				let image = UIImage(contentsOfFile: imageUrl.path)
				
				let storableData = try JSONDecoder().decode(ProfileModelStorable.self, from: text ?? Data())
				let presentableData: ProfileModel = .init(name: storableData.name, description: storableData.description, profilePicture: image)
				
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
	
	// MARK: Private methods
	
	internal func restoreFromBackup() {
		do {
			let backupDataURL = try url(for: "ProfileDataBackup", dot: "json")
			let backupImageURL = try url(for: "ProfileImageBackup", dot: "png")
			
			let imageURL = try url(for: "ProfileImage", dot: "png")
			let dataURL = try url(for: "ProfileData", dot: "json")
			
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
	
	internal func url(for fileName: String, dot fileExtension: String) throws -> URL {
		let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
		return fileURL
	}
}
