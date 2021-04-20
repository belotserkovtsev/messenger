//
//  NetworkError.swift
//  Messenger
//
//  Created by belotserkovtsev on 20.04.2021.
//

import Foundation

enum NetworkError: Error {
	case serverFailure(statusCode: Int?)
	case decodingFailure
}
