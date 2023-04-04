//
//  ViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit

class MainTabController: UITabBarController, UINavigationControllerDelegate {

//    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.selectedIndex = 2
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureViewControllers()
//        selectedIndex = 2
        self.selectedIndex = 2
        
//        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
//        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)

//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    func configureViewControllers() {
        
        tabBar.backgroundColor = UIColor.mainColor
        
        let home = templateNavigationController(
            unselectedImage: UIImage.unselectedHomeIcon,
            selectedImage: UIImage.selectedHomeIcon,
            rootViewController: HomeViewController()
        )
        
        let store = templateNavigationController(
            unselectedImage: UIImage.unselectedStoreIcon,
            selectedImage: UIImage.selectedStoreIcon,
            rootViewController: StoreViewController())
        
        let myPage = templateNavigationController(
            unselectedImage: UIImage.unselectedMyPageIcon,
            selectedImage: UIImage.selectedMyPageIcon,
            rootViewController: MyPageViewController())

        
        viewControllers = [home, store, myPage]
    }
    
    func templateNavigationController(unselectedImage: UIImage,
                                      selectedImage: UIImage,
                                      rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage.withTintColor(.black, renderingMode: .alwaysOriginal)
        nav.tabBarItem.badgeColor = .black
        
        
//        nav.tabBarItem.selectedImage = selectedImage.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
//        nav.navigationBar.tintColor = .magenta
        
        return nav
    }
}




//if let count = self.tabBar.items?.count {
//        for i in 0...(count-1) {
//            let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
//            let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
//
//            self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
//            self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
//        }
//    }
//
//    let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
//    let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
//
//    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
//    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
