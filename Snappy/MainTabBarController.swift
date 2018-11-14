//
//  MainTabBarController.swift
//  Snappy
//
//  Created by Nasim on 11/25/17.
//  Copyright © 2017 Nasim. All rights reserved.
//

import UIKit

class MainTabBarController:UITabBarController, UITabBarControllerDelegate{
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        
        setUpViewControllers()
    }
    
    func setUpViewControllers(){
        //home
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "filters_unselected"), selectedImage: #imageLiteral(resourceName: "filters_selected"), rootViewController: PhotoViewController())
        
        let portraitController = templateNavController(unselectedImage: #imageLiteral(resourceName: "background_unselected"), selectedImage: #imageLiteral(resourceName: "background_selected"), rootViewController: PortraitController())
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController, portraitController]
        
        guard let items = tabBar.items else {return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
        
    }
    
}
