//
//  IProfileFileService.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import Foundation

protocol IProfileFileService: IFileService {
	func read(completion: @escaping (ProfileDataCompletionStatus) -> Void)
	func write(data: ProfileDataModel, isFirstLaunch: Bool, completion: @escaping (ProfileDataCompletionStatus) -> Void)
}
