//
//  AboutAppViewController.swift
//  Messenger
//
//  Created by belotserkovtsev on 27.04.2021.
//

import UIKit

class AboutAppViewController: UIViewController {
	@IBOutlet var nextButton: ThemeDependentUIButton!
	@IBOutlet var titleLabel: ThemeDependentUILabel!
	@IBOutlet var descriptionTextView: UITextView!
	
	var dataModel: AboutAppModel?
	var index: Int?
	var initialSetupService: IInitialSetupService?
	
	lazy var emitterCell: CAEmitterCell = {
		var cell = CAEmitterCell()
		cell.contents = UIImage(named: "tinkoff")?.cgImage
		cell.scale = 0.01
		cell.scaleRange = 0.3
		cell.emissionRange = .pi
		cell.lifetime = 20
		cell.birthRate = 20
		cell.velocity = -40
		cell.velocityRange = -20
		cell.yAcceleration = 30
		cell.xAcceleration = 5
		cell.spin = -0.5
		cell.spinRange = 1
		return cell
	}()
	
	lazy var emitterLayer: CAEmitterLayer = {
		let layer = CAEmitterLayer()
		layer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 0)
		layer.emitterShape = CAEmitterLayerEmitterShape.point
		layer.beginTime = CACurrentMediaTime()
		layer.emitterCells = [emitterCell]
		return layer
	}()
	
	// MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		nextButton.layer.cornerRadius = 12
		titleLabel.text = dataModel?.title
		descriptionTextView.text = dataModel?.description
		nextButton.setTitle(dataModel?.buttonTitle, for: .normal)
		navigationController?.delegate = self
	}
	
	// MARK: Gestures
	@IBAction func pushNextScreen(_ sender: UIButton) {
		guard let index = index, let vc = AboutAppViewController.make(at: index + 1) else {
			initialSetupService?.completeOnboarding()
			return
		}
		navigationController?.pushViewController(vc, animated: true)
	}
}

// MARK: Nav Controller Delegate
extension AboutAppViewController: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController,
		animationControllerFor operation: UINavigationController.Operation,
		from fromVC: UIViewController,
		to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		TransitionAnimator()
	}
}

// MARK: Emitter handling
extension AboutAppViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let isInteractive = dataModel?.isInteractive, isInteractive {
			emitterLayer.lifetime = 0
			view.layer.addSublayer(emitterLayer)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let isInteractive = dataModel?.isInteractive, isInteractive {
			guard let touch = touches.first else { return }
			let position = touch.location(in: view)
			emitterLayer.emitterPosition = position
			emitterLayer.lifetime = 1
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let isInteractive = dataModel?.isInteractive, isInteractive {
			guard let touch = touches.first else { return }
			let position = touch.location(in: view)
			emitterLayer.emitterPosition = position
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let isInteractive = dataModel?.isInteractive, isInteractive {
			emitterLayer.lifetime = 0
		}
	}
}
