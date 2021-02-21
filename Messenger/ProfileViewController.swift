//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var profilePictureView: UIImageView?
	@IBOutlet weak var nameAndLastnameLabel: UILabel?
	@IBOutlet weak var editButton: UIButton?
	@IBOutlet weak var initialsLabel: UILabel?
	
	private var profilePicture: UIImage? {
		willSet {
			if let img = newValue {
				profilePictureView?.image = img
				initialsLabel?.isHidden = true
			} else {
				profilePictureView?.image = nil
				initialsLabel?.isHidden = false
			}
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		print("In \(#function): ", editButton?.frame ?? "nil")
		
//		мы получаем nil так как
//		на этом этапе вьюшки еще не созданы
	}
	
	//MARK: Image Picker
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			profilePicture = image
		}
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion:nil)
	}
	
	func presentImagePicker(_ picker: UIImagePickerController ,with sourceType: UIImagePickerController.SourceType) {
		picker.sourceType = sourceType
		self.present(picker, animated: true, completion: nil)
	}
	
	//MARK: Gestures
	@objc func handleProfilePictureTap(_ sender: UITapGestureRecognizer) {
		let alert = UIAlertController(title: "Set profile picture", message: nil, preferredStyle: .actionSheet)
		
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = false
		imagePicker.delegate = self

		alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				self.presentImagePicker(imagePicker, with: .photoLibrary)
			}
			
		}))
		
		alert.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				self.presentImagePicker(imagePicker, with: .camera)
			}
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		print("In \(#function): ", editButton?.frame ?? "nil")
		
		profilePictureView?.layer.cornerRadius = 240 / 2
		editButton?.layer.cornerRadius = 14
		editButton?.isEnabled = false
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfilePictureTap(_:)))
		profilePictureView?.addGestureRecognizer(tap)
		profilePictureView?.isUserInteractionEnabled = true
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

