//
//  GLCommit.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation

class GLCommit {
	let id: String
	let shortId: String
	let title: String
	let authorName: String
	let commitedDate: Date
	let commitedDateAgo: String
	
	init(json: [String:Any]) {
		self.id = json["id"] as! String
		self.shortId = json["short_id"] as! String
		self.title = json["title"] as! String
		self.authorName = json["author_name"] as! String
		self.commitedDate = (json["committed_date"] as! String).dateFromISO8601!
		self.commitedDateAgo = self.commitedDate.timeAgoSinceNow(useNumericDates: true)
	}
}
