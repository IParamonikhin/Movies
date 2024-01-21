//
//  TabBarController.swift
//  sf_diplom
//
//  Created by Иван on 21.01.2024.
//

import UIKit

class TabBarController: UITabBarController {

    private let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let filmListVC = UINavigationController(rootViewController: FilmListViewController())
        filmListVC.tabBarItem = UITabBarItem(title: "Films", image: UIImage(systemName: "film"), tag: 0)

        let secondVC = UINavigationController(rootViewController: SearchViewController()) 
        secondVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let thirdVC = UINavigationController(rootViewController: FavoritesViewController())
        thirdVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 2)

        viewControllers = [filmListVC, secondVC, thirdVC]
        tabBar.barTintColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.7)
    }

}
