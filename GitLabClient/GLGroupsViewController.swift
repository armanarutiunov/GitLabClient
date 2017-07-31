//
//  GLGroupsViewController.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

class GLGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	//MARK: - Properties
	
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	let viewModel = GLGroupsViewModel()
	
	let tableViewCellReuseId = "GLGroupTableViewCell"
	let tableViewHeaderReuseId = "GLGroupHeader"
	
	//MARK: - UIViewController LifeCycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupTableView()
		registerCells()
		viewModel.loadGroups()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNotificationObservers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeNotificationObservers()
	}

	//MARK: - Initialization
	
	func setupNotificationObservers() {
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(reloadTableView),
		                                       name: viewModel.notificationOfSuccess,
		                                       object: nil)
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(show(_:)),
		                                       name: viewModel.notificationOfFailure,
		                                       object: nil)
	}
	
	func removeNotificationObservers() {
		
		NotificationCenter.default.removeObserver(self,
		                                          name: viewModel.notificationOfSuccess,
		                                          object: nil)
		
		NotificationCenter.default.removeObserver(self,
		                                          name: viewModel.notificationOfFailure,
		                                          object: nil)
	}
	
	func setupTableView() {
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func registerCells() {
		tableView.register(UINib.init(nibName: tableViewCellReuseId, bundle: nil),
		                   forCellReuseIdentifier: tableViewCellReuseId)
		tableView.register(UINib.init(nibName: tableViewHeaderReuseId, bundle: nil),
		                   forHeaderFooterViewReuseIdentifier: tableViewHeaderReuseId)
	}
	
	
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.groups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseId,
		                                         for: indexPath) as! GLGroupTableViewCell
		
		let cellData = viewModel.cellData(forRowAt: indexPath)
		
		cell.groupName.text = cellData[viewModel.groupName] as? String
		cell.groupDescription.text = cellData[viewModel.groupDescription] as? String
		
		let placeholderImage = UIImage(named: "gitlab_icon")!
		cell.groupAvatarImageView.af_setImage(withURL: viewModel.getImageUrl(forIndexPath: indexPath),
		                                      placeholderImage: placeholderImage)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderReuseId)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 60
		} else {
			return CGFloat.leastNonzeroMagnitude
		}
	}
	
	//MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: - Actions
	
	func reloadTableView() {
		tableView.reloadData()
	}
	
	func show(_ error: Error) {
		showAlert(withTitle: "Error",
		          message: "Problems with API: \(error.localizedDescription)",
			andActionTitle: "OK")
	}
	
	
	
	
	
}
