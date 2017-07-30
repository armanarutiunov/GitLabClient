//
//  AppDelegate.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 26/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	
	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		setupGitLabAccountAvailability()
		
		return true
	}
	
	func setupGitLabAccountAvailability() {
		
		if let _ = GitLabAccount.loadFromKeychain() {
//			checkTokenAvailability(for: gitLabAccount)
			setupInitial(viewController: GLProjectsViewController.init(nibName: "GLProjectsViewController",
			                                                           bundle: nil))
		} else {
			setupInitial(viewController: GLAuthorizationViewController.init(nibName: "GLAuthorizationViewController",
			                                                                bundle: nil))
		}
	}
	
	//MARK: - Authorization Logic
	
//	func checkTokenAvailability(for account: GitLabAccount) {
//		
//		let expirationDate = account.grantDate.timeIntervalSince1970 + account.expiration
//		let currentDate = Date().timeIntervalSince1970
//		
//		if currentDate < expirationDate {
//		} else {
//			let authViewModel = GLAuthorizationViewModel()
//			authViewModel.requestOAuthToken(with: account.username,
//			                                and: account.password)
//		}
//	}
	
	//MARK: - Initial View Controller Setup
	
	func setupInitial(viewController: UIViewController) {
		
		window = UIWindow.init(frame: UIScreen.main.bounds)
		let navController = UINavigationController.init(rootViewController: viewController)
		window?.rootViewController = navController
		window?.makeKeyAndVisible()
	}
}

