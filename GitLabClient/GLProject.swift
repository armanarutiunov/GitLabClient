//
//  GLProject.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation

class GLProject {
	var id: Int
	var name: String
	var description: String?
	var avatarURL: String?
	
	init(json: [String : Any]) {
		self.id = json["id"] as! Int
		self.name = json["name"] as! String
		if let descr = json["description"] {
			self.description = descr as? String
		}
		if let avatar = json["avatar_url"] {
			self.avatarURL = avatar as? String
		}
	}
}
