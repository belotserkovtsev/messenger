//
//  IFileService.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import Foundation

protocol IFileService {
	func cancel(_ type: WorkItemType)
	func restoreFromBackup()
	func url(for fileName: String, dot fileExtension: String) throws -> URL
}
