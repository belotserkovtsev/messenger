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
		Console.log(#function)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Console.log(#function)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Console.log(#function)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		Console.log(#function)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		Console.log(#function)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Console.log(#function)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Console.log(#function)
	}


}

