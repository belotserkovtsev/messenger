//
//  String+lines.swift
//  Messenger
//
//  Created by belotserkovtsev on 23.03.2021.
//

import Foundation

extension String {
	var lines: [String] {
		return self.components(separatedBy: "\n")
	}
}
