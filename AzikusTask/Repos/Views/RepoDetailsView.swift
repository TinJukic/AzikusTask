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
    fileprivate static let elememtsConstant = 20.0
    
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
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
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
    private func configureView() {
        guard let repoInfo else { return }
        
        let avatarImageView = UIImageView()
        avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
        avatarImageView.roundedAvatar()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        
        let nameTextView = UITextView()
        nameTextView.text = repoInfo.name
        nameTextView.font = .boldSystemFont(ofSize: .fontSize)
        nameTextView.textAlignment = .center
        nameTextView.backgroundColor = .clear
        nameTextView.isScrollEnabled = false
        nameTextView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameTextView)
        
        let descriptionTextView = UITextView()
        descriptionTextView.text = repoInfo.description
        descriptionTextView.font = .systemFont(ofSize: .fontSize)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionTextView)
        
        let linkButton = UIButton()
        linkButton.backgroundColor = .systemGreen
        linkButton.tintColor = .black
        linkButton.setTitle("Go to repository", for: .normal)
        linkButton.addTarget(self, action: #selector(linkButtonHandler), for: .touchUpInside)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linkButton)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: .elememtsConstant),
            nameTextView.centerXAnchor.constraint(equalTo: nameTextView.superview!.centerXAnchor),
            nameTextView.centerYAnchor.constraint(equalTo: nameTextView.superview!.centerYAnchor),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionTextView.superview!.safeAreaLayoutGuide.leadingAnchor, constant: .sideConstant),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionTextView.superview!.safeAreaLayoutGuide.trailingAnchor, constant: -.sideConstant),
            descriptionTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: .elememtsConstant),
//            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: descriptionTextView.superview!.safeAreaLayoutGuide.bottomAnchor, constant: -.sideConstant),
            
            linkButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: .elememtsConstant),
            linkButton.bottomAnchor.constraint(equalTo: linkButton.superview!.safeAreaLayoutGuide.bottomAnchor, constant: -.sideConstant),
            linkButton.centerXAnchor.constraint(equalTo: linkButton.superview!.centerXAnchor),
        ])
    }
    
    @objc
    private func linkButtonHandler() {
        print("Button clicked")
        
        if let url = URL(string: repoInfo?.htmlURL ?? "") {
            let application = UIApplication.shared
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}
