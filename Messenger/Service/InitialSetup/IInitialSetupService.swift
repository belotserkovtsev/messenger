//
//  IInitialSetupService.swift
//  Messenger
//
//  Created by belotserkovtsev on 14.04.2021.
//

import UIKit

protocol IInitialSetupService {
	var initialViewController: UIViewController? { get }
	func launchSetup() -> UIWindow?
	func completeOnboarding()
}
