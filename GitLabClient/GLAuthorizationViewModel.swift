//
//  GLAuthorizationViewModel.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 29/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation
import OAuthSwift

class GLAuthorizationViewModel {
	
	let notificationOfSuccess = Notification.Name("Authorization succeed")
	let notificationOfFailure = Notification.Name("Authorization denied")
}

extension GLAuthorizationViewModel {
	
	func requestOAuthToken(withUsername username: String, andPassword password: String) {
		let oauth = setupOauth()
		oauth.startAuthorizedRequest("https://gitlab.com/oauth/token",
		                             method: .POST,
		                             parameters: ["grant_type":"password",
		                                          "username":username,
		                                          "password":password],
		success: { (response) in
			if let responseData = try? response.jsonObject() as! [String: Any] {
				guard let token = responseData["access_token"] as? String,
				let type = responseData["token_type"] as? String else {
						
						self.informOfFailure()
						return
				}
				
				let account = GitLabAccount(accessToken: token,
				                            tokenType: type,
				                            grantDate: Date())
				
				do {
					try account.save()
					self.informOfSuccess()
				} catch {
					
				}
			}
		}, failure: { (error) in
			print("Authorization was canceled or went wrong: \(error)")
			self.informOfFailure()
		})
	}
	
	
	func setupOauth() -> OAuth2Swift {
		let oauth = OAuth2Swift.init(consumerKey: "b1292ed0fa1f09a2277a94dc3d174a2a53895aafe0d411bde665e2a817d762bb",
		                             consumerSecret: "4e35c826e56b1811ee609c3517923d98093074007fcb1eb42a3c1395e7b3a5c0",
		                             authorizeUrl: "https://gitlab.com/oauth/token",
		                             responseType: "token")
		
		return oauth
	}
	
	func informOfSuccess() {
		NotificationCenter.default.post(name: self.notificationOfSuccess, object: nil)
	}
	
	func informOfFailure() {
		NotificationCenter.default.post(name: self.notificationOfFailure, object: nil)
	}
}
