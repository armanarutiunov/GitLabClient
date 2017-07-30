//
//  GLViewController.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 30/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func showAlert(withTitle title: String,
	               message: String,
	               andActionTitle actionTitle: String) {
		
		let alertController = UIAlertController.init(title: title,
		                                             message: message,
		                                             preferredStyle: UIAlertControllerStyle.alert)
		let action = UIAlertAction.init(title: actionTitle,
		                                style: UIAlertActionStyle.default,
		                                handler: nil)
		
		alertController.addAction(action)
		
		self.present(alertController,
		             animated: true,
		             completion: nil)
	}
}
