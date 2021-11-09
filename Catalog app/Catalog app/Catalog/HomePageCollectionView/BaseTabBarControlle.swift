//
//  BaseTabBarControlle.swift
//  Catalog app
//
//  Created by Macbook Pro on 09.11.2021.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let first = self.viewControllers![0] as! HomeViewController
        first.user = user
        let second = self.viewControllers![1] as! CategoriesViewController
        second.user = user
        let finalVC = self.viewControllers![2] as! ProfileViewController
        finalVC.user = user
        
    }

}
