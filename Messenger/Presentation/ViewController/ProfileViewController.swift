//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
	
	@IBOutlet weak var profilePictureView: UIImageView!
	@IBOutlet weak var editButton: ThemeDependentUIButton!
	@IBOutlet weak var saveGCDButton: ThemeDependentUIButton!
	@IBOutlet weak var initialsLabel: ThemeDependentUILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	private var isEditingProfile = false
	var fileService: IProfileFileService?
	
	private var profilePicture: UIImage? {
		willSet {
			if let img = newValue {
				profilePictureView.image = img
				initialsLabel.isHidden = true
			} else {
				profilePictureView.image = nil
				initialsLabel.isHidden = false
			}
		}
	}
	
	// MARK: Gestures
	@IBAction func editTapHandler(_ sender: UIButton) {
		if !isEditingProfile {
			startEditing()
		} else {
			cancelEditing()
		}
	}
	
	@IBAction func saveGCDTapHandler(_ sender: UIButton) {
		restrictEditing()
		activityIndicator.startAnimating()
		
		fileService?.write(data: .init(name: nameTextField.text,
									 description: descriptionTextView.text,
									 profilePicture: profilePicture), isFirstLaunch: false) { status in
			switch status {
			case .success:
				print("success")
				let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
				alert.addAction(.init(title: "Ok", style: .default, handler: { _ in self.stopEditing() }))
				self.present(alert, animated: true, completion: nil)
			case .failure(let err):
				let alert = UIAlertController(title: "Error", message: err.message, preferredStyle: .alert)
				alert.addAction(.init(title: "Ok", style: .default, handler: { _ in self.stopEditing() }))
				self.present(alert, animated: true, completion: nil)
			case .cancelled:
				print("cancelled write")
			}
			self.activityIndicator.stopAnimating()
		}
	}
	
	func gestureRecognizer(_ gr: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let bounds = profilePictureView.bounds
		let cornerRadius = profilePictureView.layer.cornerRadius
		let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		let point = touch.location(in: profilePictureView)
		return bezierPath.contains(point)
	}
	
	// MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Profile"
		
		profilePictureView.layer.cornerRadius = view.frame.width * 0.5 / 2
		editButton.layer.cornerRadius = 14
		saveGCDButton.layer.cornerRadius = 14
		
		profilePictureView.isUserInteractionEnabled = true
		nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		descriptionTextView.accessibilityIdentifier = "descriptionTextView"
		nameTextField.accessibilityIdentifier = "nameTextField"
		
		activityIndicator.startAnimating()
		fileService?.read { status in
			switch status {
			case .success(let data):
				self.descriptionTextView.text = data?.description ?? ""
				self.nameTextField.text = data?.name ?? ""
				self.profilePicture = data?.profilePicture
				self.setInitialsLabel()
			case .failure:
				print("read error")
			case .cancelled:
				print("cancelled read")
			}
			self.activityIndicator.stopAnimating()
		}
		
		_ = self.hideKeyboardWhenTappedAround()
		addGestureToImageView()
		
		nameTextField.delegate = self
		descriptionTextView.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		fileService?.cancel(.write)
		fileService?.cancel(.read)
	}
}

// MARK: Private methhods
extension ProfileViewController {
	func removeGestureFromImageView() {
		if let gesture = profilePictureView.gestureRecognizers?.first {
			profilePictureView.removeGestureRecognizer(gesture)
		}
	}
	
	func addGestureToImageView() {
		let editTap = UITapGestureRecognizer(target: self, action: #selector(profilePictureTapHandler))
		profilePictureView.addGestureRecognizer(editTap)
		editTap.delegate = self
	}
	
	private func disableSaveButton() {
		saveGCDButton.isEnabled = false
	}
	
	private func enableSaveButton() {
		saveGCDButton.isEnabled = true
		animateShakeSaveButton(in: 10)
	}
	
	private func makeTextViewsEditable() {
		descriptionTextView.isEditable = true
		nameTextField.isEnabled = true
	}
	
	private func makeTextViewsUneditable() {
		descriptionTextView.isEditable = false
		nameTextField.isEnabled = false
	}
	
	private func setInitialsLabel() {
		if let letter = nameTextField.text?.first {
			initialsLabel.text = String(letter).uppercased()
		} else {
			initialsLabel.text = ""
		}
	}
	
	private func cancelEditing() {
		stopEditing()
		activityIndicator.stopAnimating()
		
		fileService?.cancel(.write)
		
		fileService?.read { status in
			switch status {
			case .success(let data):
				self.descriptionTextView.text = data?.description ?? ""
				self.nameTextField.text = data?.name ?? ""
				self.profilePicture = data?.profilePicture
				self.setInitialsLabel()
			case .failure(let err):
				print(err)
			case .cancelled:
				print("cancelled")
			}
		}
	}
	
	private func stopEditing() {
		restrictEditing()
		
		isEditingProfile = false
		saveGCDButton.isHidden = true
		addGestureToImageView()
		editButton.setTitle("Edit", for: .normal)
	}
	
	private func restrictEditing() {
		makeTextViewsUneditable()
		disableSaveButton()
		removeGestureFromImageView()
	}
	
	private func startEditing(withSelection selection: Bool = true) {
		isEditingProfile = true
		
		saveGCDButton.isHidden = false
		
		makeTextViewsEditable()
		
		editButton.setTitle("Cancel", for: .normal)
		
		if selection {
			nameTextField.becomeFirstResponder()
			let position = descriptionTextView.endOfDocument
			descriptionTextView.selectedTextRange = descriptionTextView.textRange(from: position, to: position)
		}
	}
	
	// MARK: Animations
	private func animateShakeSaveButton(in seconds: Double = 0) {
		let initialPosition = saveGCDButton.layer.position
		
		let moveAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
		moveAnimation.values = [
			initialPosition,
			CGPoint(x: initialPosition.x, y: initialPosition.y + 2),
			CGPoint(x: initialPosition.x - 2, y: initialPosition.y + 2)
		]
		moveAnimation.keyTimes = [0, 0.5, 1]
		
		let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
		rotateAnimation.values = [
			0,
			Double.pi / 100,
			-1 * (Double.pi / 100),
			0
		]
		rotateAnimation.keyTimes = [0, 0.3, 0.6, 1]
		
		let group = CAAnimationGroup()
		group.animations = [moveAnimation, rotateAnimation]
		group.autoreverses = true
		group.repeatCount = 2
		group.duration = 0.2
		group.isRemovedOnCompletion = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
			self?.saveGCDButton.layer.add(group, forKey: "animations")
		}
	}
}

// MARK: OBJC Handlers
extension ProfileViewController {
	@objc func profilePictureTapHandler() {
		let alert = UIAlertController(title: "Set profile picture", message: nil, preferredStyle: .actionSheet)
		
		switch ThemeService.currentTheme {
		case .night:
			if #available(iOS 13, *) {
				alert.overrideUserInterfaceStyle = .dark
			}
		default:
			break
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
				self.presentImagePicker(with: .photoLibrary)
			}))
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			alert.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { _ in
				self.presentImagePicker(with: .camera)
			}))
		}
		
		alert.addAction(UIAlertAction(title: "Upload", style: .default, handler: { _ in
//			print("Selected network")
			if let vc = ImageSelectionViewController.make() {
				vc.avatarDelegate = self
				self.present(vc, animated: true, completion: nil)
			}
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardSize.height / 2
			}
		}
	}
	
	@objc private func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
	
	@objc private func textFieldDidChange() {
		setInitialsLabel()
	}
}

// MARK: Image Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			profilePicture = image
			startEditing(withSelection: false)
			enableSaveButton()
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = sourceType
		imagePicker.allowsEditing = false
		imagePicker.delegate = self
		self.present(imagePicker, animated: true, completion: nil)
	}
}

// MARK: TextView Delegate
extension ProfileViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currentText = textView.text ?? ""
		if let gcd = saveGCDButton, !gcd.isEnabled {
			enableSaveButton()
		}
		
		guard let stringRange = Range(range, in: currentText) else { return false }
		let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
		return updatedText.count <= 60
	}
}

extension ProfileViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let gcd = saveGCDButton, !gcd.isEnabled {
			enableSaveButton()
		}
		return true
	}
}

extension ProfileViewController: AvatarDelegate {
	func didSelectAvatar(image: UIImage?) {
		guard let image = image else {
			let alert = UIAlertController(title: "Error", message: "Unable to load selected image", preferredStyle: .alert)
			alert.addAction(.init(title: "Ok", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		profilePicture = image
		startEditing(withSelection: false)
		enableSaveButton()
	}
}
