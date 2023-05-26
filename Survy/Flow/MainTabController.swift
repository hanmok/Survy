//
//  ViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit

class MainTabController: UITabBarController, UINavigationControllerDelegate, Coordinating {
    var coordinator: Coordinator?
    

//    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.selectedIndex = 2
//    }
    
    var provider: ProviderType
    
    init(provider: ProviderType, coordinator: Coordinator) {
        self.provider = provider
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureViewControllers()
//        selectedIndex = 2
        self.selectedIndex = 0
        self.provider.commonService.setSelectedIndex(0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    
    
    func configureViewControllers() {
        
        tabBar.backgroundColor = UIColor.mainColor
        guard let coordinator = self.coordinator else { fatalError() }
        
        let homeVC = HomeViewController(index: 0, participationService: self.provider.participationService, userService: self.provider.userService)
        
        homeVC.title = "홈"
        homeVC.coordinator = coordinator
        
        let storeVC = StoreViewController(index: 1)
        storeVC.title = "스토어"
        
        let myPageVC = MyPageViewController(index: 2)
        myPageVC.title = "마이페이지"
        
        let home = templateNavigationController(
            unselectedImage: UIImage.unselectedHomeIcon,
            selectedImage: UIImage.selectedHomeIcon,
            rootViewController: homeVC
        )
        
        let store = templateNavigationController(
            unselectedImage: UIImage.unselectedStoreIcon,
            selectedImage: UIImage.selectedStoreIcon,
            rootViewController: storeVC)
        
        let myPage = templateNavigationController(
            unselectedImage: UIImage.unselectedMyPageIcon,
            selectedImage: UIImage.selectedMyPageIcon,
            rootViewController: myPageVC)

        viewControllers = [home, store, myPage]
        
    }
    
    func templateNavigationController(unselectedImage: UIImage,
                                      selectedImage: UIImage,
                                      rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.tabBarItem.image = unselectedImage
        
        // icon color
        nav.tabBarItem.selectedImage = selectedImage.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        return nav
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = self.tabBar.items,
              let idx = items.firstIndex(of: item) else {
                  fatalError()
              }
        provider.commonService.setSelectedIndex(idx)
    }
}
