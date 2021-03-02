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
	
	@IBAction func handleDismissTap(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
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
		
		alert.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				self.presentImagePicker(with: .camera)
			}
		}))
		
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
		title = "Profile"
		
		profilePictureView?.layer.cornerRadius = 240 / 2
		editButton?.layer.cornerRadius = 14
		editButton?.isEnabled = false
		
		nameAndLastnameLabel?.preferredMaxLayoutWidth = 280
		descriptionLabel?.preferredMaxLayoutWidth = 200
		
		let editTap = UITapGestureRecognizer(target: self, action: #selector(handleProfilePictureTap))
		profilePictureView?.addGestureRecognizer(editTap)
		profilePictureView?.isUserInteractionEnabled = true
		
		editTap.delegate = self
	}


}

