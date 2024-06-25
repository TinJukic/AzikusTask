//
//  ReposCellView.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation
import UIKit

extension UIImageView {
    fileprivate func load(urlString: String) {
        guard let imageURL = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    fileprivate func roundedAvatar() {
        layer.borderWidth = 0.1
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}

extension CGFloat {
    fileprivate static let imageSize = 50.0
    fileprivate static let fontSize = 20.0
    fileprivate static let sideConstant = 10.0
    fileprivate static let elememtsConstant = 20.0
    
}

/// Table view cell styling and functionality
class ReposCellView: UITableViewCell {
    static let cellIdentifier = "cellId"
    
    var repoInfo: RepoInfo? {
        didSet {
            styleCell()
        }
    }
    
    // styling elements
    private let avatarImageView: UIImageView
    private let nameTextView: UITextView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        avatarImageView = UIImageView()
        nameTextView = UITextView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)

        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameTextView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: avatarImageView.superview!.leadingAnchor, constant: .sideConstant),
            avatarImageView.topAnchor.constraint(equalTo: avatarImageView.superview!.topAnchor, constant: .sideConstant),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarImageView.superview!.bottomAnchor, constant: -.sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            
            nameTextView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: .elememtsConstant),
            nameTextView.trailingAnchor.constraint(equalTo: nameTextView.superview!.trailingAnchor, constant: -.sideConstant),
            nameTextView.topAnchor.constraint(equalTo: nameTextView.superview!.topAnchor, constant: .sideConstant),
            nameTextView.bottomAnchor.constraint(equalTo: nameTextView.superview!.bottomAnchor, constant: -.sideConstant),
        ])
        
        styleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper functions

extension ReposCellView {
    private func styleCell() {
        if let repoInfo {
            avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
            nameTextView.text = repoInfo.name
        } else {
            avatarImageView.tintColor = .systemGreen
            nameTextView.text = "Not available"
        }
        
        avatarImageView.roundedAvatar()
        nameTextView.font = .boldSystemFont(ofSize: .fontSize)
        nameTextView.backgroundColor = .clear
    }
}
