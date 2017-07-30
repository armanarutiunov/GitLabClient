//
//  GLActivityIndicator.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 30/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

protocol GLLoading {
	func showActivity()
	func hideActivity()
	func setIsLoading(_ isLoading: Bool)
}

extension GLLoading {
	func setIsLoading(_ isLoading: Bool) {
		if isLoading {
			self.showActivity()
		} else {
			self.hideActivity()
		}
	}
}

extension UIView: GLLoading {
	func showActivity() {
		let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		
		self.addSubview(activity)
		
		activity.frame = self.bounds
		activity.startAnimating()
	}
	
	func hideActivity() {
		for subview in subviews {
			if subview is UIActivityIndicatorView {
				subview.removeFromSuperview()
			}
		}
	}
}

extension UIViewController: GLLoading {
	func showActivity() {
		view.showActivity()
	}
	
	func hideActivity() {
		view.hideActivity()
	}
}
