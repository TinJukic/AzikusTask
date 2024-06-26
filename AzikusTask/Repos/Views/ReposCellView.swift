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
    fileprivate static let elementsConstant = 20.0
    
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
    private let nameLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        avatarImageView = UIImageView()
        nameLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        generateCellElements()
        styleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper functions

extension ReposCellView {
    private func generateCellElements() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: avatarImageView.superview!.leadingAnchor, constant: .sideConstant),
            avatarImageView.topAnchor.constraint(equalTo: avatarImageView.superview!.topAnchor, constant: .sideConstant),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarImageView.superview!.bottomAnchor, constant: -.sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: .elementsConstant),
            nameLabel.trailingAnchor.constraint(equalTo: nameLabel.superview!.trailingAnchor, constant: -.sideConstant),
            nameLabel.topAnchor.constraint(equalTo: nameLabel.superview!.topAnchor, constant: .sideConstant),
            nameLabel.bottomAnchor.constraint(equalTo: nameLabel.superview!.bottomAnchor, constant: -.sideConstant),
        ])
    }
    
    private func styleCell() {
        if let repoInfo {
            avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
            nameLabel.text = repoInfo.name
        } else {
            avatarImageView.tintColor = .systemGreen
            nameLabel.text = "Not available"
        }
        
        avatarImageView.roundedAvatar()
        nameLabel.font = .boldSystemFont(ofSize: .fontSize)
        nameLabel.backgroundColor = .clear
    }
}
