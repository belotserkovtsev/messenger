//
//  ViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
	
	@IBOutlet weak var profilePictureView: UIImageView?
	@IBOutlet weak var editButton: ThemeDependentUIButton?
	@IBOutlet weak var saveGCDButton: ThemeDependentUIButton?
	@IBOutlet weak var saveOperationsButton: ThemeDependentUIButton?
	@IBOutlet weak var initialsLabel: ThemeDependentUILabel?
	@IBOutlet weak var descriptionTextView: UITextView?
	@IBOutlet weak var nameTextField: UITextField?
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView?
	
	private var isEditingProfile = false
	private var gcdManager = GCDManager()
	
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
	
	//MARK: Gestures
	@IBAction func editTapHandler(_ sender: UIButton) {
		if !isEditingProfile {
			startEditing()
		} else {
			cancelEditing()
		}
	}
	
	@IBAction func saveOperationsTapHandler(_ sender: UIButton) {
		
	}
	
	@IBAction func saveGCDTapHandler(_ sender: UIButton) {
		restrictEditing()
		activityIndicator?.startAnimating()
		
		gcdManager.save(data:.init(name: nameTextField?.text,
									 description: descriptionTextView?.text,
									 profilePicture: profilePicture)) { status in
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
				print("cancelled")
			}
			self.activityIndicator?.stopAnimating()
		}
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
		
		profilePictureView?.layer.cornerRadius = view.frame.width * 0.5 / 2
		editButton?.layer.cornerRadius = 14
		saveGCDButton?.layer.cornerRadius = 14
		saveOperationsButton?.layer.cornerRadius = 14
		
		profilePictureView?.isUserInteractionEnabled = true
		nameTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default
			.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		activityIndicator?.startAnimating()
		GCDManager().get() { status in
			switch status{
			case .success(let data):
				self.descriptionTextView?.text = data?.description ?? ""
				self.nameTextField?.text = data?.name ?? ""
				self.profilePicture = data?.profilePicture
				self.setInitialsLabel()
			case .failure(let err):
				print(err)
			case .cancelled:
				print("cancelled")
			}
			self.activityIndicator?.stopAnimating()
		}
		
		self.hideKeyboardWhenTappedAround()
		nameTextField?.delegate = self
		descriptionTextView?.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		gcdManager.cancel(.write)
		gcdManager.cancel(.read)
	}
}

//MARK: Private methhods
extension ProfileViewController {
	func removeGestureFromImageView() {
		if let gesture = profilePictureView?.gestureRecognizers?.first {
			profilePictureView?.removeGestureRecognizer(gesture)
		}
	}
	
	func addGestureToImageView() {
		let editTap = UITapGestureRecognizer(target: self, action: #selector(profilePictureTapHandler))
		profilePictureView?.addGestureRecognizer(editTap)
		editTap.delegate = self
	}
	
	private func disableSaveButtons() {
//		descriptionTextView?.isEditable = false
//		nameTextField?.isEnabled = false
		saveGCDButton?.isEnabled = false
		saveOperationsButton?.isEnabled = false
	}
	
	private func enableSaveButtons() {
//		descriptionTextView?.isEditable = true
//		nameTextField?.isEnabled = true
		saveGCDButton?.isEnabled = true
		saveOperationsButton?.isEnabled = true
	}
	
	private func makeTextViewsEditable() {
		descriptionTextView?.isEditable = true
		nameTextField?.isEnabled = true
	}
	
	private func makeTextViewsUneditable() {
		descriptionTextView?.isEditable = false
		nameTextField?.isEnabled = false
	}
	
	private func setInitialsLabel() {
		if let letter = nameTextField?.text?.first {
			initialsLabel?.text = String(letter).uppercased()
		} else {
			initialsLabel?.text = ""
		}
	}
	
	private func cancelEditing() {
		stopEditing()
		gcdManager.cancel(.write)
		activityIndicator?.stopAnimating()
		GCDManager().get() { status in
			switch status {
			case .success(let data):
				self.descriptionTextView?.text = data?.description ?? ""
				self.nameTextField?.text = data?.name ?? ""
				self.profilePicture = data?.profilePicture
				self.setInitialsLabel()
			case .failure(let err):
				print(err)
			case .cancelled:
				print("cancelled")
			}
		}
	}
	
	private func stopEditing(andHideButtons hideButtons: Bool = true) {
		restrictEditing()
		
		isEditingProfile = false
		if hideButtons {
			saveGCDButton?.isHidden = true
			saveOperationsButton?.isHidden = true
		}
		
		editButton?.setTitle("Edit", for: .normal)
	}
	
	private func restrictEditing() {
		makeTextViewsUneditable()
		disableSaveButtons()
		removeGestureFromImageView()
	}
	
	private func startEditing(withSelection selection: Bool = true) {
		isEditingProfile = true
		
		saveGCDButton?.isHidden = false
		saveOperationsButton?.isHidden = false
		
		makeTextViewsEditable()
		
		editButton?.setTitle("Cancel", for: .normal)
		
		addGestureToImageView()
		
		if selection {
			nameTextField?.becomeFirstResponder()
			let newPosition = descriptionTextView?.endOfDocument
			descriptionTextView?.selectedTextRange = descriptionTextView?
				.textRange(from: newPosition!, to: newPosition!)
		}
	}
}

//MARK: OBJC Handlers
extension ProfileViewController {
	@objc func profilePictureTapHandler() {
		let alert = UIAlertController(title: "Set profile picture", message: nil, preferredStyle: .actionSheet)
		
		switch ThemeManager.currentTheme {
		case .night:
			if #available(iOS 13, *) {
				alert.overrideUserInterfaceStyle = .dark
			}
		default:
			break
		}
		
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

//MARK: Image Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			profilePicture = image
			enableSaveButtons()
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
}

//MARK: TextView Delegate
extension ProfileViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currentText = textView.text ?? ""
		if let gcd = saveGCDButton, let operations = saveOperationsButton, !gcd.isEnabled, !operations.isEnabled{
			enableSaveButtons()
		}
		
		guard let stringRange = Range(range, in: currentText) else { return false }
		let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
		return updatedText.count <= 60
	}
}

extension ProfileViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let gcd = saveGCDButton, let operations = saveOperationsButton, !gcd.isEnabled, !operations.isEnabled{
			enableSaveButtons()
		}
		return true
	}
}
