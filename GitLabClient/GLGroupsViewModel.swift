//
//  GLGroupsViewModel.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit
import AlamofireImage

class GLGroupsViewModel {
	
	let notificationOfSuccess = Notification.Name("Loaded groups")
	let notificationOfFailure = Notification.Name("Failed at loading groups")
	
	var groups = [GLGroup]()
	
	let groupName = "group_name"
	let groupDescription = "group_description"
	let groupAvatar = "groupAvatar"
}

extension GLGroupsViewModel {
	
	func loadGroups() {
		GLAPIManager.shared.getGroups(onResponse: { responseGroups in
			self.groups = responseGroups
			NotificationCenter.default.post(name: self.notificationOfSuccess, object: nil)
		}, onFailure: { error in
			NotificationCenter.default.post(name: self.notificationOfFailure, object: nil)
		})
	}
	
	func cellData(forRowAt indexPath: IndexPath) -> [String:AnyObject] {
		
		var dict = [groupName : groups[indexPath.row].name]
		
		if let description = groups[indexPath.row].description {
			dict[groupDescription] = description
		}
		
		return dict as [String : AnyObject]
	}
	
	func getImageUrl(forIndexPath indexPath: IndexPath) -> URL {
		
		let url: URL
		
		if let avatarURLString = groups[indexPath.row].avatarURL {
			url = URL(string: avatarURLString)!
		} else {
			url = URL(string: "https://example.com")!
		}
		
		return url
	}
	
	func getHeaderView(tableView: UITableView) -> UIView {
		let headerView = UIView(frame: CGRect(x: 0,
		                                      y: 0,
		                                      width: tableView.frame.size.width,
		                                      height: 60))
		let label = UILabel(frame: CGRect(x: 16,
		                                  y: 0,
		                                  width: tableView.frame.size.width,
		                                  height: 60))
		
		label.font = UIFont.boldSystemFont(ofSize: 30)
		headerView.addSubview(label)
		return headerView
	}
}
