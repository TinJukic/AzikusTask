//
//  ReposViewController.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import UIKit

/// Handles loading of data
enum LoadingResult: Equatable {
    case success
    case failure(LoadingErrors)
}

/// Handles loading errors
enum LoadingErrors: Error {
    case loadingError
}

/// Main view controller of the app
class ReposViewController: UIViewController {
    private let network = NetworkRequests.shared
    
    private let tableView = UITableView()
    private var repos = [RepoInfo]()
    private let reloadButton = UIButton()
    private let loadSpinner = UIActivityIndicatorView(style: .medium)
    
    // used for pagination
    private var currentPage = 1
    private let refreshControl = UIRefreshControl()
    
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
        
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        reloadButton.backgroundColor = .systemGreen
        reloadButton.layer.cornerRadius = 5
        reloadButton.isHidden = true
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reloadButton)
        
        loadSpinner.hidesWhenStopped = true
        loadSpinner.frame = view.bounds
        loadSpinner.isHidden = false
        
        NSLayoutConstraint.activate([
            reloadButton.centerXAnchor.constraint(equalTo: reloadButton.superview!.centerXAnchor),
            reloadButton.centerYAnchor.constraint(equalTo: reloadButton.superview!.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            reloadButton.heightAnchor.constraint(equalToConstant: CGFloat(44)),
        ])
        
        loadData { result in
            switch result {
            case .success:
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = true
                    self.loadSpinner.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = false
                    self.loadSpinner.stopAnimating()
                }
            }
        }
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
            // spinner
            let spinner = UIActivityIndicatorView(style: .medium)
            let button = UIButton()
            
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                spinner.startAnimating()
                spinner.hidesWhenStopped = true
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
                
                tableView.tableFooterView = spinner
                
                button.setTitle("Reload", for: .normal)
                button.backgroundColor = .systemGreen
                button.addTarget(self, action: #selector(footerReloadButtonHandler), for: .touchUpInside)
                button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
                button.layer.cornerRadius = 5
                button.isHidden = true
                
                tableView.tableFooterView?.isHidden = false
            }
            
            loadData { result in
                switch result {
                case .success:
                    spinner.stopAnimating()
                    tableView.tableFooterView?.isHidden = true
                    button.isHidden = true
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        button.isHidden = false
                        spinner.stopAnimating()
                        tableView.tableFooterView = button
                        
                    }
                }
            }
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
    private func loadData(completionHandler: @escaping(LoadingResult) -> Void) {
        network.fetchRepos(pageNumber: currentPage) { [weak self] newRepos in
            guard let self = self, let newRepos else {
                completionHandler(.failure(.loadingError))
                return
            }
            
            repos.append(contentsOf: newRepos)
            DispatchQueue.main.async {
                self.currentPage += 1
                self.tableView.reloadData()
                completionHandler(.success)
            }
        }
    }
    
    /// Refreshes table view data
    @objc
    private func refreshData() {
        // reset the counter and repos list
        loadSpinner.startAnimating()
        
        // the code is copied, because of the refresh control,
        // which needs to be stopped after the refresh is done
        network.fetchRepos(pageNumber: 1) { [weak self] newRepos in
            guard let self = self, let newRepos else { return }
            
            currentPage = 1
            repos = newRepos
            DispatchQueue.main.async {
                self.currentPage += 1
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.reloadButton.isHidden = true
                self.loadSpinner.stopAnimating()
            }
        }
    }
    
    /// Handles presses to refresh button inside the footer of the table view
    @objc
    private func footerReloadButtonHandler() {
        // the only thing that needs to be done here is try to reload
        // table view data, the data fetching process will continue automatically
        tableView.reloadData()
    }
}
