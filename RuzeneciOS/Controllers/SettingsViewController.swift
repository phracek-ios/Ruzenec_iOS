//
//  SettingsViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension SettingsViewController {
    
    func setupUI() {
        title = "Settings"
        view.backgroundColor = .white
    }
}
