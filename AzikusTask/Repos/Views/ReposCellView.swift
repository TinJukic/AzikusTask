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
    private let descriptionLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        avatarImageView = UIImageView()
        nameLabel = UILabel()
        descriptionLabel = UILabel()
        
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
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // name, description, image
            nameLabel.leadingAnchor.constraint(equalTo: nameLabel.superview!.leadingAnchor, constant: .sideConstant),
            nameLabel.trailingAnchor.constraint(equalTo: nameLabel.superview!.trailingAnchor, constant: -.sideConstant),
            nameLabel.topAnchor.constraint(equalTo: nameLabel.superview!.topAnchor, constant: .sideConstant),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionLabel.superview!.leadingAnchor, constant: .sideConstant),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: descriptionLabel.superview!.trailingAnchor, constant: -.sideConstant),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .elementsConstant),
            descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.4),  // max width = 40% of the cell width
            
            avatarImageView.leadingAnchor.constraint(equalTo: avatarImageView.superview!.leadingAnchor, constant: .sideConstant),
            avatarImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .elementsConstant),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarImageView.superview!.bottomAnchor, constant: -.sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
        ])
    }
    
    private func styleCell() {
        if let repoInfo {
            avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
            nameLabel.text = repoInfo.name
            descriptionLabel.text = repoInfo.description
        } else {
            avatarImageView.tintColor = .systemGreen
            nameLabel.text = "Not available"
            descriptionLabel.text = "Not available"
        }
        
        avatarImageView.roundedAvatar()
        nameLabel.font = .boldSystemFont(ofSize: .fontSize)
        nameLabel.backgroundColor = .clear
    }
}
