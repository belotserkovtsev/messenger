//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		Console.conditionalLog(#function)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Console.conditionalLog(#function)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Console.conditionalLog(#function)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		Console.conditionalLog(#function)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		Console.conditionalLog(#function)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Console.conditionalLog(#function)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Console.conditionalLog(#function)
	}


}

