//
//  TransitionAnimator.swift
//  Messenger
//
//  Created by belotserkovtsev on 28.04.2021.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		0.2
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let duration = transitionDuration(using: transitionContext)
		let container = transitionContext.containerView
		
		container.addSubview(toView)
		toView.alpha = 0
		
		UIView.animate(withDuration: duration, animations: {
			toView.alpha = 1
		}, completion: { _ in
			transitionContext.completeTransition(true)
		})
	}
}
