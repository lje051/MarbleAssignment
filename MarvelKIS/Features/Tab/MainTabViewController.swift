//
//  MainTabViewController.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import UIKit
import RxSwift
import RxCocoa

final class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.overrideUserInterfaceStyle = .light
        tabBar.isTranslucent = false
        let controllers: [UIViewController] = HomeTabBarItem.allCases.map {
            let vc = $0.controller
            return vc
        }
        navigationController?.hidesBarsOnSwipe = true
        self.setViewControllers(controllers, animated: false)
    }


}
