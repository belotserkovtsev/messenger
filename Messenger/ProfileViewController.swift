//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

	@IBOutlet weak var profilePicture: UIView?
	@IBOutlet weak var nameAndLastname: UILabel?
	@IBOutlet weak var editButton: UIButton?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		print("In \(#function): ", editButton?.frame ?? "nil")
		
//		мы получаем nil так как
//		на этом этапе вьюшки еще не созданы
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("In \(#function): ", editButton?.frame ?? "nil")
		
		profilePicture?.layer.cornerRadius = 240 / 2
		editButton?.layer.cornerRadius = 14
		editButton?.isEnabled = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		print("In \(#function): ", editButton?.frame ?? "nil")
		
//		к моменту вызова viewDidLoad вьюшки будут созданы,
//		но границы и размеры еще не установлены.
//		Из-за того, что в сториборде мы работаем
//		с айфоном 5, а запускаем на айфоне 11 к моменту вызова
//		viewDidAppear фрейм будет сдвинут по y,
//		чтобы соответсвовать констрейнам.
	}


}

