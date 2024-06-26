//
//  RepoDetailsView.swift
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
    fileprivate static let imageSize = 100.0
    fileprivate static let fontSize = 20.0
    fileprivate static let sideConstant = 10.0
    fileprivate static let elementsConstant = 20.0
    
}

/// Enables repo details transfer
protocol RepoDetailsViewProtocol {
    func setRepoInfo(repoInfo: RepoInfo) -> Void
}

/// Displays the information for selected repo
class RepoDetailsView: UIView {
    private var repoInfo: RepoInfo? {
        didSet {
            configureView()
        }
    }
    
    // view elements
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let fullNameLabel = UILabel()
    private let nodeIdLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let linkButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - RepoDetailsViewProtocol

extension RepoDetailsView: RepoDetailsViewProtocol {
    func setRepoInfo(repoInfo: RepoInfo) {
        self.repoInfo = repoInfo
    }
}

// MARK: - Helper functions

extension RepoDetailsView {
    private func setupViews() {
        avatarImageView.roundedAvatar()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        
        nameLabel.font = .boldSystemFont(ofSize: .fontSize)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        fullNameLabel.font = .systemFont(ofSize: .fontSize)
        fullNameLabel.textAlignment = .center
        fullNameLabel.backgroundColor = .clear
        fullNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        fullNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fullNameLabel)
        
        nodeIdLabel.font = .systemFont(ofSize: .fontSize)
        nodeIdLabel.textAlignment = .center
        nodeIdLabel.backgroundColor = .clear
        nodeIdLabel.numberOfLines = 0
        nodeIdLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nodeIdLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nodeIdLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nodeIdLabel)
        
        descriptionLabel.font = .systemFont(ofSize: .fontSize)
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        linkButton.backgroundColor = .systemGreen
        linkButton.tintColor = .black
        linkButton.setTitle("Go to repository", for: .normal)
        linkButton.layer.cornerRadius = 5
        linkButton.layer.borderWidth = 0
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linkButton)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: .elementsConstant),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sideConstant),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sideConstant),
            
            fullNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .elementsConstant),
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sideConstant),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sideConstant),
            
            nodeIdLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: .elementsConstant),
            nodeIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sideConstant),
            nodeIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sideConstant),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionLabel.superview!.safeAreaLayoutGuide.leadingAnchor, constant: .sideConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionLabel.superview!.safeAreaLayoutGuide.trailingAnchor, constant: -.sideConstant),
            descriptionLabel.topAnchor.constraint(equalTo: nodeIdLabel.bottomAnchor, constant: 2 * .elementsConstant),
            
            linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 3 * .elementsConstant),
            linkButton.bottomAnchor.constraint(lessThanOrEqualTo: linkButton.superview!.safeAreaLayoutGuide.bottomAnchor, constant: -.sideConstant),
            linkButton.centerXAnchor.constraint(equalTo: linkButton.superview!.centerXAnchor),
        ])
    }
    
    private func configureView() {
        guard let repoInfo else { return }
        
        avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
        nameLabel.text = repoInfo.name
        fullNameLabel.text = repoInfo.fullName
        nodeIdLabel.text = repoInfo.nodeId
        descriptionLabel.text = repoInfo.description
        linkButton.addTarget(self, action: #selector(linkButtonHandler), for: .touchUpInside)
    }
    
    @objc
    private func linkButtonHandler() {
        if let url = URL(string: repoInfo?.htmlURL ?? "") {
            let application = UIApplication.shared
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}
