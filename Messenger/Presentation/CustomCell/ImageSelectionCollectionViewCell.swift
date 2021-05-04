//
//  ImageSelectionCollectionViewCell.swift
//  Messenger
//
//  Created by belotserkovtsev on 19.04.2021.
//

import UIKit

class ImageSelectionCollectionViewCell: UICollectionViewCell {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var height: NSLayoutConstraint!
	@IBOutlet var width: NSLayoutConstraint!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		imageView.clipsToBounds = true
		activityIndicator.hidesWhenStopped = true
		
		if #available(iOS 13.0, *) {
			activityIndicator.style = .medium
		} else {
			activityIndicator.style = .gray
		}
		
		activityIndicator.startAnimating()
    }
	
	func configure(width: CGFloat, height: CGFloat, image: UIImage?) {
		imageView.image = image
		
		if image != nil {
			activityIndicator.stopAnimating()
		} else {
			activityIndicator.startAnimating()
		}
		self.height.constant = height
		self.width.constant = width
	}
}
