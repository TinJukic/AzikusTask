//
//  NetworkRequests.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation

/// Interface for network requests
protocol NetworkRequestsProtocol {
    /// Fetctes all repos from URL
    func fetchRepos(completionHandler: @escaping([RepoInfo]?) -> Void) -> Void
}

/// All network requests implemented
class NetworkRequests: NetworkRequestsProtocol {
    /// Private init for singleton pattern
    private init() {}
    
    /// Singleton pattern - shared instance of the NetworkRequests class
    static var shared: NetworkRequestsProtocol = {
        return NetworkRequests()
    }()
    
    private let networking = Networking.shared
    
    func fetchRepos(completionHandler: @escaping([RepoInfo]?) -> Void) {
        guard let reposURL = URL(string: .APILink) else { return }
        
        var reposRequest = URLRequest(url: reposURL)
        reposRequest.httpMethod = "GET"
        reposRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard networking.hasMore() else {
            completionHandler(nil)
            return
        }
        
        networking.executeRequest(reposRequest) { (result: Result<[RepoInfo], NetworkingErrors>) in
            
            switch result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
}
