//
//  GLCommitsViewModel.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import Foundation

class GLCommitViewModel {
	
	let notificationOfSuccess = Notification.Name("Loaded Commits")
	let notificationOfFailure = Notification.Name("Failed at loading commits")
	
	var commits = [GLCommit]()
	var sortedCommits = [[GLCommit]]()
	
	let shortId = "short_id"
	let title = "title"
	let authorAndDateAgo = "author_and_date_ago"
	let commitedDate = "commited_date"
}

extension GLCommitViewModel {
	
	func loadCommits(forProject project: Int) {
		GLAPIManager.shared.getCommits(forProject: project, onResponse: { responseCommits in
			self.commits = responseCommits
			NotificationCenter.default.post(name: self.notificationOfSuccess, object: nil)
		}, onFailure: { error in
			NotificationCenter.default.post(name: self.notificationOfFailure, object: nil)
		})
	}
	
	func cellData(forRowAt indexPath: IndexPath) -> [String : String] {
		
		let dict = [shortId : commits[indexPath.row].shortId,
		            title : commits[indexPath.row].title,
		            authorAndDateAgo : "\(commits[indexPath.row].authorName) commited \(commits[indexPath.row].commitedDateAgo)"]
		
		return dict as [String : String]
	}
	
	func splitDataToSections() {
		
		commits.sort{$0.commitedDate < $1.commitedDate}
		commits = commits.sorted(by: { $0.commitedDate.compare($1.commitedDate) == .orderedDescending})
		
		for commit in commits {
			let calendar = Calendar.current
			let day = calendar.component(.day, from: commit.commitedDate)
			let month = calendar.component(.month, from: commit.commitedDate)
			let year = calendar.component(.year, from: commit.commitedDate)
			if let previousDay = sortedCommits.last, let previousCommit = previousDay.last{
				
				let dayOfPreviousCommit = calendar.component(.day, from: previousCommit.commitedDate)
				let monthOfPreviousCommit = calendar.component(.month, from: previousCommit.commitedDate)
				let yearOfPreviousCommit = calendar.component(.year, from: previousCommit.commitedDate)
				
				if day == dayOfPreviousCommit &&
					month == monthOfPreviousCommit &&
					year == yearOfPreviousCommit{
					
					let prevDayIndex = sortedCommits.count - 1
					let prevDayAmount = sortedCommits[prevDayIndex].count
					sortedCommits[prevDayIndex].insert(commit, at: prevDayAmount)
					
				} else {
					sortedCommits.append([commit])
				}
			} else {
				sortedCommits.append([commit])
			}
		}
        if sortedCommits.count > 0 {
            print(sortedCommits[0][0].authorName)
        }
	}
	
	func headerLabel(forSection section: Int) -> String {
		
		let date = sortedCommits[section][0].commitedDate
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM, yyyy"
		let formattedDate = formatter.string(from: date)
		let amountOfCommits = sortedCommits[section].count
		if amountOfCommits == 1 {
			return "\(formattedDate) \(amountOfCommits) commit"
		} else {
			return "\(formattedDate) \(amountOfCommits) commits"
		}
	}
}
