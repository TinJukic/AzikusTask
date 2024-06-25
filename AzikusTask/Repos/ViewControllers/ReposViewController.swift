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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove
        view.backgroundColor = .systemRed
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReposCellView.self, forCellReuseIdentifier: "cellId")
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        fetchRepos()
    }
    
    override func loadView() {
        super.loadView()
        
//        let reposView = ReposView()
//        reposView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(reposView)
//        
//        NSLayoutConstraint.activate([
//            reposView.leadingAnchor.constraint(equalTo: reposView.superview!.leadingAnchor),
//            reposView.trailingAnchor.constraint(equalTo: reposView.superview!.trailingAnchor),
//            reposView.topAnchor.constraint(equalTo: reposView.superview!.topAnchor),
//            reposView.bottomAnchor.constraint(equalTo: reposView.superview!.bottomAnchor),
//        ])
        
//        network.fetchRepos() { result in
//            guard let result else {
//                print("Nema rezultata")
//                return
//            }
//            
//            print("Ima rezultata")
//            result.forEach { info in
//                print(info)
//            }
//        }
    }
}

// MARK: - UITableViewDataSource

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(repos)
        return repos.count
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
            fetchRepos()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push another view controller here
        let viewController = RepoDetailsViewController()
        viewController.setRepoInfo(repoInfo: repos[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Helper functions

extension ReposViewController {
    private func fetchRepos() {
        network.fetchRepos { [weak self] newRepos in
            guard let self = self, let newRepos else { return }
            
            repos.append(contentsOf: newRepos)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
