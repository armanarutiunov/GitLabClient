//
//  GLProjectsViewModel.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 30/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation

class GLProjectsViewModel {
	
	let notificationOfSuccess = Notification.Name("Loaded projects")
	let notificationOfFailure = Notification.Name("Failed at loading projects")
	
	var projects = [GLProject]()
	
	let projectName = "project_name"
	let projectDescription = "project_description"	
}

extension GLProjectsViewModel {
	
	func loadProjects(forGroup group: Int) {
		GLAPIManager.shared.getProjects(forGroup: group, onResponse: { responseProjects in
			self.projects = responseProjects
			NotificationCenter.default.post(name: self.notificationOfSuccess, object: nil)
		}, onFailure: { error in
			NotificationCenter.default.post(name: self.notificationOfFailure, object: nil)
		})
	}
	
	func cellData(forRowAt indexPath: IndexPath) -> [String:AnyObject] {
		
		var dict = [projectName : projects[indexPath.row].name]
		
		if let description = projects[indexPath.row].description {
			dict[projectDescription] = description
		}
		
		return dict as [String : AnyObject]
	}
	
	func getImageUrl(forIndexPath indexPath: IndexPath) -> URL {
		
		let url: URL
		
		if let avatarURLString = projects[indexPath.row].avatarURL {
			url = URL(string: avatarURLString)!
		} else {
			url = URL(string: "https://example.com")!
		}
		
		return url
	}
}
