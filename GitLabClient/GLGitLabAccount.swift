//
//  GLGitLabAccount.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 29/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation
import Locksmith

struct GitLabAccount {
	let accessToken: String
	let tokenType: String
	let grantDate: Date
	
	static let service = "GitLab"
}

extension GitLabAccount {
	
	//ключи для избежания опечаток
	struct Keys {
		static let username = "username"
		static let password = "password"
		static let accessToken = "access_token"
		static let tokenType = "token_type"
		static let grantDate = "grantDate"
	}
	
	func save() throws{
		try Locksmith.saveData(data: [Keys.accessToken: accessToken, Keys.tokenType: tokenType, Keys.grantDate: grantDate.timeIntervalSince1970], forUserAccount: GitLabAccount.service)
	}
	
	static func loadFromKeychain() -> GitLabAccount? {
		guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: GitLabAccount.service), let token = dictionary[Keys.accessToken] as? String, let type = dictionary[Keys.tokenType] as? String, let grantDateValue = dictionary[Keys.grantDate] as? TimeInterval else {
			return nil
		}
		
		let grantDate = Date(timeIntervalSince1970: grantDateValue)
		
		return GitLabAccount(accessToken: token,
		                     tokenType: type,
		                     grantDate: grantDate)
	}
}
