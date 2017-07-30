//
//  GLAuthorizationViewController.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 26/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

class GLAuthorizationViewController: UIViewController {
	
	//MARK: - Properties
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signInButton: UIButton!
	
	let viewModel = GLAuthorizationViewModel()
	
	//MARK: - UIViewController Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		setupHeaderView()
		setupSignInButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNotificationObservers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		dismissNotificationObservers()
	}
	
	//MARK: - Initialization
	
	func setupNotificationObservers() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(enterGitLab),
		                                       name: viewModel.notificationOfSuccess,
		                                       object: nil)
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(showFailureAlert),
		                                       name: viewModel.notificationOfFailure,
		                                       object: nil)
	}
	
	func dismissNotificationObservers() {
		NotificationCenter.default.removeObserver(self,
		                                          name: viewModel.notificationOfSuccess,
		                                          object: nil)
		
		NotificationCenter.default.removeObserver(self,
		                                          name: viewModel.notificationOfFailure,
		                                          object: nil)
	}
	
	func setupHeaderView() {
		headerView.layer.borderColor = UIColor.lightGray.cgColor
		headerView.layer.borderWidth = 1
	}
	
	func setupSignInButton() {
		signInButton.layer.cornerRadius = 4
	}
	
	//MARK: - Actions
	
	@IBAction func signInButtonPressed(_ sender: Any) {
		if let username = usernameTextField.text,
			let password = passwordTextField.text {
			viewModel.requestOAuthToken(withUsername: username,
			                            andPassword: password)
		}
	}
	
	func enterGitLab() {
		self.navigationController?.pushViewController(GLProjectsViewController.init(nibName: "GLProjectsViewController",
		                                                                            bundle: nil),
		                                              animated: true)
	}
	
	func showFailureAlert() {
		showAlert(withTitle: "Cannot Sign In",
		          message: "The user name or password is incorrect",
		          andActionTitle: "OK")
	}
	
	
}