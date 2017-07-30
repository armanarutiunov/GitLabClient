//
//  GLNetworkingManager.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 30/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation
import Alamofire

class GLAPIManager {
	
	typealias GLJSONObject = [String:Any]
	
	static let shared = GLAPIManager()
	
	static let baseUrlString = "https://gitlab.com/lib/api/"
	
	func getURL(forMethod method: String) -> String {
		return "\(GLAPIManager.baseUrlString)\(method)"
	}
	
	
	func get(method: String,
	         parameters: GLJSONObject,
	         success: @escaping ((Any) -> Void),
	         failure: @escaping ((Error)-> Void)) {
		
		var params = parameters
		
		if let account = GitLabAccount.loadFromKeychain() {
			params["access_token"] = account.accessToken
		}
		
		Alamofire.request(getURL(forMethod: method), parameters: params).responseJSON { response in
			
			if case let .failure(error) = response.result {
				print(error.localizedDescription)
				failure(error)
				return
			}
			
			if let json = response.result.value {
				success(json as Any)
			}
		}
	}
}
