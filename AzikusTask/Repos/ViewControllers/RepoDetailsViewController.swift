//
//  RepoDetailsViewController.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation
import UIKit

class RepoDetailsViewController: UIViewController {
    private let repoView: RepoDetailsView
    
    
    init() {
        repoView = RepoDetailsView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = repoView
    }
}

// MARK: - Helper functions

extension RepoDetailsViewController {
    func setRepoInfo(repoInfo: RepoInfo) {
        repoView.setRepoInfo(repoInfo: repoInfo)
        navigationItem.title = repoInfo.name ?? ""
    }
}
