//
//  Date+hasPassed.swift
//  Messenger
//
//  Created by belotserkovtsev on 05.04.2021.
//

import Foundation

extension Date {
	func hasPassedSinceNow(for component: Calendar.Component, duration: Int) -> Bool {
		let inputDate = self
		
		let calendar = Calendar.current
		let startOfNow = Date()
		let startOfTimeStamp = inputDate
		
		let components = calendar.dateComponents([component], from: startOfNow, to: startOfTimeStamp)
		let someComponent: Int?
		
		switch component {
		case .day:
			someComponent = components.day
		case .hour:
			someComponent = components.hour
		case .minute:
			someComponent = components.minute
		default:
			someComponent = components.day
		}
		
		if let minute = someComponent {
			if abs(minute) >= duration {
				return false
			} else {
				return true
			}
		}
		return false
	}
}
