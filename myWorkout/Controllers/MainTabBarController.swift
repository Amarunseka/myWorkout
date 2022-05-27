//
//  MainTabBarController.swift
//  myWorkout
//
//  Created by Миша on 12.04.2022.
//

import UIKit
//import RealmSwift

class MainTabBarController: UITabBarController {
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)

        setupTabBar()
        setupView()
    }
    
    // MARK: - methods-actions
    private func setupTabBar() {
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderColor = UIColor.specialBrown.cgColor
        tabBar.layer.borderWidth = 1
    }
    
    private func setupView(){
//        let mainVC = EditProfileViewController()
        let mainVC = MainViewController()
        let statisticVC = StatisticViewController()
        let profileVC = ProfileInfoViewController()

        setViewControllers([mainVC, statisticVC, profileVC], animated: true)
        
        guard let items = tabBar.items else {return}
        
        items[0].title = "Main"
        items[0].image = UIImage(named: "mainTabBarImage")
        
        items[1].title = "Statistic"
        items[1].image = UIImage(named: "statisticTabBarImage")
        
        items[2].title = "Profile"
        items[2].image = UIImage(named: "profileTabBarImage")


        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.robotoBold12() as Any], for: .normal)
    }
}


/*
 КАК ВОЗМОЖНЫЙ ВАРИАНТ СОЗДАВАТЬ АЙТЕМЫ ПО ДРУГОМУ
 
 для того, чтобы вьюконтролеры потом могли пушить на другие вьюконтролеры надо сразу создавать навигешены с рутовыми ВК, а не просто ВК
 let statisticVC = UINavigationController(rootViewController: StatisticViewController())

 
 let mainVCImage = UIImage(named: "mainTabBarImage")
 let statisticVCImage = UIImage(named: "statisticTabBarImage")
 
 mainVC.tabBarItem = UITabBarItem(
     title: "Main",
     image: mainVCImage,
     tag: 0)

 statisticVC.tabBarItem = UITabBarItem(
     title: "Statistic",
     image: statisticVCImage,
     tag: 1)

 setViewControllers([mainVC, statisticVC], animated: true)
 
 
 // А ТАК СОЗДАЮТСЯ ДЛЯ ЦВЕТНЫХ КАРТИНОК
 let item = UITabBarItem(
     title: title,
     image: mainVCImage.withRenderingMode(.alwaysTemplate),
     selectedImage: mainVCImage.withRenderingMode(.alwaysOriginal)
 )
 */
