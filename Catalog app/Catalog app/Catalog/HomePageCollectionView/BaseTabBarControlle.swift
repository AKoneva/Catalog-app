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
        let second = self.viewControllers![1] as! CategoriesViewController
        let third = self.viewControllers![2] as! ProfileViewController
        
        first.user = user
        second.user = user
        third.user = user
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let first = self.viewControllers![0] as! HomeViewController
        let second = self.viewControllers![1] as! CategoriesViewController
        let third = self.viewControllers![2] as! ProfileViewController
        
        user = first.user
        second.user = user
        third.user = user
        
    }
}
