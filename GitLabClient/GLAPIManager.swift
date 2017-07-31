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
	
	static let baseUrlString = "https://gitlab.com/api/v4/"
	
	func getURL(forMethod method: String) -> String {
		return "\(GLAPIManager.baseUrlString)\(method)"
	}
	
	
	func get(method: String,
	         parameters: GLJSONObject,
	         success: @escaping (([GLJSONObject]) -> Void),
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
				success(json as! [GLJSONObject])
			}
		}
	}
	
	func getGroups(onResponse: @escaping (([GLGroup]) -> Void),
	               onFailure: @escaping ((Error) -> Void)) {
		
		get(method: "groups",
		    parameters: [:],
		    success: { response in
				
				var groups = [GLGroup]()
				for dict in response {
					let group = GLGroup.init(json: dict)
					groups.append(group)
				}
				onResponse(groups)
				
		}, failure: { error in
			onFailure(error)
		})
	}
	
	func getProjects(forGroup groupId:Int,
	                 onResponse: @escaping (([GLProject]) -> Void),
	                 onFailure: @escaping ((Error) -> Void)) {
		get(method: "groups/\(groupId)/projects",
		    parameters: [:],
		    success: { response in
				
				var projects = [GLProject]()
				for dict in response {
					projects.append(GLProject.init(json:dict))
				}
				onResponse(projects)
				
		}, failure: { error in
			onFailure(error)
		})
	}
	
	func getCommits(forProject projectId:Int,
	                 onResponse: @escaping (([GLCommit]) -> Void),
	                 onFailure: @escaping ((Error) -> Void)) {
		
		let currentDate = Date()
		let currentDateInSecs = currentDate.timeIntervalSince1970
		let sinceDateInSecs = currentDateInSecs - 864000
		let sinceDate = Date(timeIntervalSince1970: sinceDateInSecs)
		let sinceDateString = sinceDate.iso8601
		
		get(method: "projects/\(projectId)/repository/commits",
			parameters: ["since" : sinceDateString],
			success: { response in
				
				var commits = [GLCommit]()
				for dict in response {
					commits.append(GLCommit.init(json:dict))
				}
				onResponse(commits)
				
		}, failure: { error in
			onFailure(error)
		})
	}
}

extension Formatter {
	static let iso8601: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
		return formatter
	}()
}

extension Date {
	var iso8601: String {
		return Formatter.iso8601.string(from: self)
	}
}

public extension String {
	var dateFromISO8601: Date? {
		return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
	}
}
















