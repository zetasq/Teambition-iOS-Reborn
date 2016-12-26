//
//  MainViewController.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 24/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import UIKit
import SafariServices
import SnapKit

final class MainViewController: UIViewController {
    enum DataTime {
        case today
        case tomorrow
        case future
    }
    
    // MARK: - Private Properties
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(self.refreshControlPulled(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.separatorInset = .zero
        tableView.backgroundColor = .white
        tableView.refreshControl = self.refreshControl
        tableView.estimatedRowHeight = 30
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClassForCell(type: MainTaskCell.self)
        tableView.registerClassForCell(type: MainSubtaskCell.self)
        tableView.registerClassForCell(type: MainEventCell.self)
        
        return tableView
    }()
    
    private var isLoading = false
    private var isFirstAppear = true
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerNotificationHandlers()
        
        if let _ = AccessTokenAdapter.accessToken {
            loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear {
            isFirstAppear = false
            
            if AccessTokenAdapter.accessToken == nil {
                routeToLogin()
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Register Notification Handlers
    private func registerNotificationHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.accessTokenFetched(_:)), name: TinboxNotification.accessTokenFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.invalidAccessToken(_:)), name: TinboxNotification.invalidAccessToken, object: nil)
    }
    
    // MARK: - Notification Handlers
    func accessTokenFetched(_ notification: Notification) {
        dismiss(animated: true) { 
            self.loadData()
        }
    }
    
    func invalidAccessToken(_ notification: Notification) {
        routeToLogin()
    }
    
    // MARK: - Action Handlers
    func refreshControlPulled(_ control: UIRefreshControl) {
        loadData()
    }
    
    // MARK: - Helper Methods
    private func loadData() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        RecentDataManager.requestRecentData { result in
            self.refreshControl.endRefreshing()
            self.isLoading = false
            
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                log.error("Request recent data failed: " + error.localizedDescription)
            }
        }
    }
    
    private func routeToLogin() {
        guard presentedViewController == nil else {
            return
        }
        
        let authorizeURL = OAuth2Manager.generateAuthorizeURL()
        let safariViewController = SFSafariViewController(url: authorizeURL)
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableView DataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return RecentDataManager.todayItems.count
        case 1:
            return RecentDataManager.tomorrowItems.count
        case 2:
            return RecentDataManager.futureItems.count
        default:
            fatalError("Invalid tableview section: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, let row):
            let todayItem = RecentDataManager.todayItems[row]
            
            switch todayItem {
            case .task(let task):
                let cell = tableView.dequeueReusableCell(type: MainTaskCell.self, for: indexPath)
                
                cell.config(with: task, time: .today)
                
                return cell
            case .subtask(let subtask):
                let cell = tableView.dequeueReusableCell(type: MainSubtaskCell.self, for: indexPath)
                
                cell.config(with: subtask, time: .today)
                
                return cell
            case .event(let event):
                let cell = tableView.dequeueReusableCell(type: MainEventCell.self, for: indexPath)
                
                cell.config(with: event, time: .today)
                
                return cell
            }
        case (1, let row):
            let tomorrowItem = RecentDataManager.tomorrowItems[row]
            
            switch tomorrowItem {
            case .task(let task):
                let cell = tableView.dequeueReusableCell(type: MainTaskCell.self, for: indexPath)
                
                cell.config(with: task, time: .tomorrow)
                
                return cell
            case .subtask(let subtask):
                let cell = tableView.dequeueReusableCell(type: MainSubtaskCell.self, for: indexPath)
                
                cell.config(with: subtask, time: .tomorrow)
                
                return cell
            case .event(let event):
                let cell = tableView.dequeueReusableCell(type: MainEventCell.self, for: indexPath)
                
                cell.config(with: event, time: .tomorrow)
                
                return cell
            }
        case (2, let row):
            let futureItem = RecentDataManager.futureItems[row]
            
            switch futureItem {
            case .task(let task):
                let cell = tableView.dequeueReusableCell(type: MainTaskCell.self, for: indexPath)
                
                cell.config(with: task, time: .future)
                
                return cell
            case .subtask(let subtask):
                let cell = tableView.dequeueReusableCell(type: MainSubtaskCell.self, for: indexPath)
                
                cell.config(with: subtask, time: .future)
                
                return cell
            case .event(let event):
                let cell = tableView.dequeueReusableCell(type: MainEventCell.self, for: indexPath)
                
                cell.config(with: event, time: .future)
                
                return cell
            }
        default:
            fatalError("Invalid tablview indexpath: section = \(indexPath.section), row = \(indexPath.row))")
        }
    }
}

// MARK: - UITableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
