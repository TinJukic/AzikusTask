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
    fileprivate static let elementsConstant = 30.0
    fileprivate static let buttonPadding = 5.0
    
}

extension UIStackView {
    fileprivate func configureText(withText text: String) {
        let label = arrangedSubviews[1] as! UILabel
        label.text = text
    }
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
    private var fullNameStackView: UIStackView?
    private var nodeIdStackView: UIStackView?
    private var descriptionStackView: UIStackView?
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
    /// Generates initial view elements
    private func setupViews() {
        avatarImageView.roundedAvatar()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        
        fullNameStackView = generateStackView(title: "Full name")
        fullNameStackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fullNameStackView!)
        
        nodeIdStackView = generateStackView(title: "Node ID")
        nodeIdStackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nodeIdStackView!)
        
        descriptionStackView = generateStackView(title: "Node description")
        descriptionStackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionStackView!)
        
        linkButton.backgroundColor = .systemGreen
        linkButton.tintColor = .black
        linkButton.setTitle("Go to repository", for: .normal)
        linkButton.layer.cornerRadius = 5
        linkButton.layer.borderWidth = 0
        linkButton.contentEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linkButton)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sideConstant),
            avatarImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            fullNameStackView!.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: .elementsConstant),
            fullNameStackView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sideConstant),
            fullNameStackView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sideConstant),
            
            nodeIdStackView!.topAnchor.constraint(equalTo: fullNameStackView!.bottomAnchor, constant: .elementsConstant),
            nodeIdStackView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .sideConstant),
            nodeIdStackView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sideConstant),
            
            descriptionStackView!.leadingAnchor.constraint(equalTo: descriptionStackView!.superview!.safeAreaLayoutGuide.leadingAnchor, constant: .sideConstant),
            descriptionStackView!.trailingAnchor.constraint(equalTo: descriptionStackView!.superview!.safeAreaLayoutGuide.trailingAnchor, constant: -.sideConstant),
            descriptionStackView!.topAnchor.constraint(equalTo: nodeIdStackView!.bottomAnchor, constant: .elementsConstant),
            
            linkButton.topAnchor.constraint(equalTo: descriptionStackView!.bottomAnchor, constant: 3 * .elementsConstant),
            linkButton.bottomAnchor.constraint(lessThanOrEqualTo: linkButton.superview!.safeAreaLayoutGuide.bottomAnchor, constant: -.sideConstant),
            linkButton.centerXAnchor.constraint(equalTo: linkButton.superview!.centerXAnchor),
        ])
    }
    
    /// Configures view elements with passed data
    private func configureView() {
        guard let repoInfo else { return }
        
        avatarImageView.load(urlString: repoInfo.owner?.avatarURL ?? "")
        fullNameStackView?.configureText(withText: repoInfo.fullName ?? "")
        nodeIdStackView?.configureText(withText: repoInfo.nodeId ?? "")
        descriptionStackView?.configureText(withText: repoInfo.description ?? "")
        linkButton.addTarget(self, action: #selector(linkButtonHandler), for: .touchUpInside)
    }
    
    @objc
    private func linkButtonHandler() {
        if let url = URL(string: repoInfo?.htmlURL ?? "") {
            let application = UIApplication.shared
            application.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /// Used for generating stack views
    private func generateStackView(title: String, text: String = "") -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = .sideConstant
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: .fontSize)
        stackView.addArrangedSubview(titleLabel)
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: .fontSize)
        stackView.addArrangedSubview(textLabel)
        
        return stackView
    }
}
