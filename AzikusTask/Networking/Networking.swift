//
//  Networking.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation
import UIKit

/// Errors while generating network calls
enum NetworkingErrors: Error {
    case clientError
    case serverError
    case noDataError
    case dataDecodingError(String)
}

/// Interface for communication with network
protocol NetworkingProtocol {
    /// Executes desired request
    func executeRequest<T: Decodable>(
        _ request: URLRequest,
        completionHandler: @escaping(Result<T, NetworkingErrors>
    ) -> Void) -> Void
    
    /// Checks whether more data could be loaded
    /// Returns true if more data could be loaded, false otherwise
    /// Page address is parsed, as described here: "https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api?apiVersion=2022-11-28#about-pagination"
    func hasMore() -> Bool
}

/// Executes network calls
class Networking: NetworkingProtocol {
    // attributes necessary for pagination
    private var isFetching = false
    private var hasNext = true
    
    /// Private init for singleton pattern
    private init() {}
    
    /// Singleton pattern - shared instance of the NetworkRequests class
    static var shared: NetworkingProtocol = {
        return Networking()
    }()
    
    func executeRequest<T: Decodable>(
        _ request: URLRequest,
        completionHandler: @escaping(Result<T, NetworkingErrors>
    ) -> Void) {
        
        guard !isFetching && hasNext else { return }
        isFetching = true
        
        let dataFetch = URLSession.shared.dataTask(with: request) { data, response, error in
            // should be always executed
            defer { self.isFetching = false }
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            self.parseLinkHeader(httpResponse: httpResponse)
            
            guard let data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            var value: T!  // decoded data
            do {
                value = try JSONDecoder().decode(T.self, from: data)
            } catch let jsonError as NSError {
                completionHandler(.failure(.dataDecodingError(jsonError.localizedDescription)))
                return
            }
            
            completionHandler(.success(value))
        }
        
        dataFetch.resume()
    }
    
    func hasMore() -> Bool {
        hasNext
    }
}

// MARK: - Helper functions

extension Networking {
    private func parseLinkHeader(httpResponse: HTTPURLResponse) {
        guard let linkHeader = httpResponse.value(forHTTPHeaderField: "link") else {
            hasNext = false
            return
        }
        
        let links = linkHeader.split(separator: ",").map { $0.split(separator: ";") }
        for link in links {
            _ = link[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            let relPart = link[1].trimmingCharacters(in: CharacterSet(charactersIn: " \""))
            if relPart == "rel=\"next" {
                hasNext = true
                return
            }
        }
        
        hasNext = false
    }
}
