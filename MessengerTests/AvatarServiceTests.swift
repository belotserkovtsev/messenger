//
//  MessengerTests.swift
//  MessengerTests
//
//  Created by belotserkovtsev on 04.05.2021.
//

@testable import Messenger
import XCTest

class AvatarServiceTests: XCTestCase {
    func testServiceCallCount() throws {
		let service = AvatarServiceMock(imageStub: { UIImage() })
		_ = ImageSelectionViewController.make(avatarService: service)
		
		XCTAssertEqual(service.calls, 1)
    }
	
	func testVcIsNotNil() throws {
		let service = AvatarServiceMock(imageStub: { UIImage() })
		let vc = ImageSelectionViewController.make(avatarService: service)
		
		XCTAssertNotNil(vc)
	}
}
