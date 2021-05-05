//
//  ImageSelectionViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit

class ImageSelectionViewController: UIViewController {
	@IBOutlet var collectionView: ThemeDependentUICollectionView?
	@IBOutlet var activityIndicator: UIActivityIndicatorView?
	
	private let reuseIdentifier = "ImageCell"
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	private let itemsPerRow: CGFloat = 3
	lazy private var widthAndHeight = widthForItem()
	
	var avatarService: IAvatarService?
	var dataModel = ImageSelectionModel()
	weak var avatarDelegate: AvatarDelegate?
	
	// MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.dataSource = self
		collectionView?.delegate = self
		activityIndicator?.hidesWhenStopped = true
		
		if #available(iOS 13.0, *) {
			activityIndicator?.style = .medium
		} else {
			activityIndicator?.style = .gray
		}
		
		activityIndicator?.startAnimating()
		
		collectionView?.register(UINib(nibName: String(describing: ImageSelectionCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
	}
	
	func handle(error: AvatarError) {
		switch error {
		case .unableToLoad(let index):
			dataModel.unableToLoad(at: index)
			collectionView?.reloadData()
		case .unableToLoadAny:
			let alert = UIAlertController(title: "Error", message: "Unable to load images. Please try again later", preferredStyle: .alert)
			alert.addAction(.init(title: "Ok", style: .default) { _ in
				self.dismiss(animated: true, completion: nil)
			})
			present(alert, animated: true, completion: nil)
		}
	}
	
	private func widthForItem() -> CGFloat {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		return widthPerItem
	}
}

// MARK: CollectionViewDataSource
extension ImageSelectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		dataModel.images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
				as? ImageSelectionCollectionViewCell else { return UICollectionViewCell() }
		if let image = dataModel.images[indexPath.row] {
			cell.configure(width: widthAndHeight, height: widthAndHeight, image: image)
		} else {
			cell.configure(width: widthAndHeight, height: widthAndHeight, image: nil)
		}
		return cell
	}
	
}

// MARK: CollectionViewDelegate
extension ImageSelectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: widthAndHeight, height: widthAndHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		sectionInsets.left
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let image = dataModel.image(for: indexPath)
		dismiss(animated: true, completion: nil)
		avatarDelegate?.didSelectAvatar(image: image)
	}
}
