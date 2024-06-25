//
//  NavigationViewController.swift
//  AzikusTask
//
//  Created by Tin on 25.06.2024..
//

import Foundation
import UIKit

class NavigationViewController: UINavigationController {
    override func loadView() {
        super.loadView()
        
        pushViewController(ReposViewController(), animated: true)
    }
}
