//
//  ReposViewController.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import UIKit

/// Main view controller of the app
class ReposViewController: UIViewController {
    let network = NetworkRequests.shared
    
    private let tableView = UITableView()
    private var repos = [RepoInfo]()
    
    // used for pagination
    var currentPage = 1
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Repositories"
        navigationItem.largeTitleDisplayMode = .automatic
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReposCellView.self, forCellReuseIdentifier: "cellId")
        tableView.frame = view.bounds
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        
        loadData()
    }
}

// MARK: - UITableViewDataSource

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ReposCellView
        cell.repoInfo = repos[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 {
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push another view controller here
        let viewController = RepoDetailsViewController()
        viewController.setRepoInfo(repoInfo: repos[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Helper functions

extension ReposViewController {
    /// Loads data from server for the specific page
    private func loadData() {
        network.fetchRepos(pageNumber: currentPage) { [weak self] newRepos in
            guard let self = self, let newRepos else { return }
            
            repos.append(contentsOf: newRepos)
            DispatchQueue.main.async {
                self.currentPage += 1
                self.tableView.reloadData()
            }
        }
    }
    
    /// Refreshes table view data
    @objc
    private func refreshData() {
        // reset the counter and repos list
        currentPage = 1
        
        // the code is copied, because of the refresh control,
        // which needs to be stopped after the refresh is done
        network.fetchRepos(pageNumber: currentPage) { [weak self] newRepos in
            guard let self = self, let newRepos else { return }
            
            repos = newRepos
            DispatchQueue.main.async {
                self.currentPage += 1
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}
