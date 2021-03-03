//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController,
							 UIImagePickerControllerDelegate,
							 UINavigationControllerDelegate,
							 UIGestureRecognizerDelegate {
	
	@IBOutlet weak var profilePictureView: UIImageView?
	@IBOutlet weak var nameAndLastnameLabel: UILabel?
	@IBOutlet weak var editButton: UIButton?
	@IBOutlet weak var initialsLabel: UILabel?
	@IBOutlet weak var descriptionLabel: UILabel?
	
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
	
	func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = sourceType
		imagePicker.allowsEditing = false
		imagePicker.delegate = self
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	//MARK: Gestures
	@objc func handleProfilePictureTap(_ sender: UITapGestureRecognizer) {
		let alert = UIAlertController(title: "Set profile picture", message: nil, preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				self.presentImagePicker(with: .photoLibrary)
			}
		}))
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			alert.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
				self.presentImagePicker(with: .camera)
			}))
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func gestureRecognizer(_ gr: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if let bounds = profilePictureView?.bounds, let cornerRadius = profilePictureView?.layer.cornerRadius {
			let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
			let point = touch.location(in: profilePictureView)
			return bezierPath.contains(point)
		}
		return false
	}
	
	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		print("In \(#function): ", editButton?.frame ?? "nil")
		
		profilePictureView?.layer.cornerRadius = 240 / 2
		editButton?.layer.cornerRadius = 14
		editButton?.isEnabled = false
		
		nameAndLastnameLabel?.preferredMaxLayoutWidth = 280
		descriptionLabel?.preferredMaxLayoutWidth = 200
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfilePictureTap(_:)))
		profilePictureView?.addGestureRecognizer(tap)
		profilePictureView?.isUserInteractionEnabled = true
		
		tap.delegate = self
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

