//
//  AvatarError.swift
//  Messenger
//
//  Created by belotserkovtsev on 20.04.2021.
//

import Foundation

enum AvatarError: Error {
	case unableToLoad(at: Int)
	case unableToLoadAny
}
