//
//  RuzenecTabBarController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 01.10.2026.
//  Copyright © 2026 Petr Hracek. All rights reserved.
//

import UIKit

class RuzenecTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Novény"
        let desatekLayout = UICollectionViewFlowLayout()
        let desatekCollectionViewController = DesatekCollectionViewController(collectionViewLayout: desatekLayout)
        desatekCollectionViewController.tabBarItem = UITabBarItem(title: "Základní", image: UIImage(named: "ic_home"), tag: 0)
        desatekCollectionViewController.tabBarItem.badgeColor = KKCTextLightMode

        let pompejLayout = UICollectionViewFlowLayout()
        let pompejPrayViewController = JineCollectionViewController(collectionViewLayout: pompejLayout)
        pompejPrayViewController.tabBarItem = UITabBarItem(title: "Jiné", image: UIImage(named: "ic_book"), tag: 1)
        pompejPrayViewController.tabBarItem.badgeColor = KKCTextLightMode

        
        let settingsLayout = UICollectionViewFlowLayout()
        let settingsTableViewController = SettingsCollectionViewController(collectionViewLayout: settingsLayout)
        settingsTableViewController.tabBarItem = UITabBarItem(title: "Nastavení", image: UIImage(named: "ic_settings"), tag: 2)
        settingsTableViewController.tabBarItem.badgeColor = KKCTextLightMode
        
        let tabBarList = [desatekCollectionViewController, pompejPrayViewController, settingsTableViewController]
        
        viewControllers = tabBarList
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIBarStyle.black]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    // MARK: - Navigation

}
