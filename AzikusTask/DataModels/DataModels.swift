//
//  DataModels.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation

/// Struct with repo data
struct RepoInfo: Codable, Equatable {
    /// Repo ID
    var id: Int?
    /// Node ID
    var nodeId: String?
    /// Repo name
    var name: String?
    /// Repo full name
    var fullName: String?
    /// Repo visibility
    var privateRepo: Bool?
    /// Information about repo's owner
    var owner: Owner?
    /// URL which leads to the repo
    var htmlURL: String?
    /// Basic repo description
    var description: String?
    
    // the rest of the data is not going to be used
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case fullName = "full_name"
        case privateRepo = "private"
        case owner
        case htmlURL = "html_url"
        case description
    }
}

/// Information about owner of the repo
struct Owner: Codable, Equatable {
    /// GitHub organisation
    var login: String?
    /// Repo owner ID
    var id: Int?
    /// Node ID
    var nodeId: String?
    /// URL of the avatar image
    var avatarURL: String?
    
    // the rest of the data is not going to be used
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
    }
}
