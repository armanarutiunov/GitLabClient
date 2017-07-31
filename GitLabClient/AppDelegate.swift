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
			setupInitial(viewController: GLGroupsViewController.init(nibName: "GLGroupsViewController",
			                                                           bundle: nil))
		} else {
			setupInitial(viewController: GLAuthorizationViewController.init(nibName: "GLAuthorizationViewController",
			                                                                bundle: nil))
		}
	}
	
	//MARK: - Initial View Controller Setup
	
	func setupInitial(viewController: UIViewController) {
		
		window = UIWindow.init(frame: UIScreen.main.bounds)
		let navController = UINavigationController.init(rootViewController: viewController)
		navController.isNavigationBarHidden = true
		window?.rootViewController = navController
		window?.makeKeyAndVisible()
	}
}

