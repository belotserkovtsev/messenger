//
//  SaveOperation.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.03.2021.
//

import UIKit

class SaveOperation: AsyncOperation {
	var dataModel: ProfileDataModel?
	
	override func main() {
		do {
			guard let data = dataModel else {
				cancel()
				return
			}
			
			let userDataFileURL = try self.getUrl(for: "ProfileData", dot: "json")
			let imageDataFileURL = try self.getUrl(for: "ProfileImage", dot: "png")
			
			let storableData: ProfileDataStorable = .init(name: data.name, description: data.description)
			
			let jsonData = try JSONEncoder().encode(storableData)
			let imageData = data.profilePicture?.jpegData(compressionQuality: 1)
			
			sleep(3)
			try jsonData.write(to: userDataFileURL)
			try imageData?.write(to: imageDataFileURL)
			
			let backupDataURL = try self.getUrl(for: "ProfileDataBackup", dot: "json")
			let backupImageURL = try self.getUrl(for: "ProfileImageBackup", dot: "png")
			
			let jsonBackupData = jsonData
			try jsonBackupData.write(to: backupDataURL)
			
			let backupImageData = imageData
			try backupImageData?.write(to: backupImageURL)
			
			if isCancelled {
				self.restoreFromBackup()
			} else {
				let backupDataURL = try self.getUrl(for: "ProfileDataBackup", dot: "json")
				let backupImageURL = try self.getUrl(for: "ProfileImageBackup", dot: "png")

				let jsonBackupData = jsonData
				try jsonBackupData.write(to: backupDataURL)

				let backupImageData = imageData
				try backupImageData?.write(to: backupImageURL)
				currentState = .finished
			}
			
		} catch {
			return
		}
	}
	
	private func getUrl(for fileName: String, dot fileExtension: String) throws -> URL {
		let documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
		return fileURL
	}
	
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
			print("error with writing to backup")
		}
		
	}
}
