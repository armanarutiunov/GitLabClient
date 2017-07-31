//
//  GLCommitsViewController.swift
//  GitLabClient
//
//  Created by Arman Arutyunov on 31/07/2017.
//  Copyright © 2017 Arman Arutyunov. All rights reserved.
//

import UIKit

class GLCommitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: - Properties
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backButton: UIButton!
	var baseProjectId: Int = 0
	
	let tableViewCellReuseId = "GLCommitTableViewCell"
	
	let viewModel = GLCommitViewModel()
	
	//MARK: - UIViewController LifeCycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupTableView()
		registerCells()
		viewModel.loadCommits(forProject: baseProjectId)
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
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
	}
	
	func registerCells() {
		tableView.register(UINib.init(nibName: tableViewCellReuseId, bundle: nil),
		                   forCellReuseIdentifier: tableViewCellReuseId)
	}
	
	//MARK: - UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.sortedCommits.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sortedCommits[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseId, for: indexPath) as! GLCommitTableViewCell
		let cellData = viewModel.cellData(forRowAt: indexPath)
		
		cell.commitName.text = cellData[viewModel.title]
		cell.shortId.text = cellData[viewModel.shortId]
		cell.authorAndDate.text = cellData[viewModel.authorAndDateAgo]
		
		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
		let label = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: 44))
		label.text = viewModel.headerLabel(forSection: section)
		label.textColor = UIColor.black
		label.font = UIFont.systemFont(ofSize: 15)
		
		view.addSubview(label)
		
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}
	
    // MARK: - Actions
	
	@IBAction func backButtonPressed(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func reloadTableView() {
		viewModel.splitDataToSections()
		tableView.reloadData()
	}
	
	func show(_ error: Error) {
		showAlert(withTitle: "Error",
		          message: "Problems with API: \(error.localizedDescription)",
			andActionTitle: "OK")
	}


}
