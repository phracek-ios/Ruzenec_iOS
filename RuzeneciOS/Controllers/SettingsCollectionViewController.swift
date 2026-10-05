//
//  SettingsCollectionViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 01.10.2026.
//  Copyright © 2026 Petr Hracek. All rights reserved.
//

import UIKit
import os.log
import FirebaseAnalytics

class SettingsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    enum RowType {
        case desatek
        case settings
        case about
    }
    
    struct RowData {
        let type: RowType
        let desatek: Desatek?
    }

    var className: String {
        return String(describing: self)
    }
    //MARK: Properties
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    let userDefaults = UserDefaults.standard

    fileprivate var desatky = [Desatek]()
    fileprivate var rowData = [RowData]()
    fileprivate var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Seznam desatku",
                                       AnalyticsParameterScreenClass: className])
        loadRowData()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Růženec"

        let dimmOff = userDefaults.bool(forKey: keys.idleTimer)
        if dimmOff == true {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        self.darkMode = userDefaults.bool(forKey: keys.night)
        if self.darkMode {
            self.collectionView!.backgroundColor = KKCBackgroundNightMode
        } else {
            self.collectionView!.backgroundColor = KKCBackgroundLightMode
        }
        self.collectionView?.reloadData()
        navigationController?.navigationBar.barTintColor = UIColor.white//KKCMainTextColor
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection != nil else { return }
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.register(DesatekCollectionViewCell.self, forCellWithReuseIdentifier: DesatekCollectionViewCell.cellId)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    // MARK: - Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesatekCollectionViewCell.cellId, for: indexPath) as! DesatekCollectionViewCell
        let data = rowData[indexPath.row]
        var name: String = ""
        var image_name: String = ""
        if data.type == .settings {
            name = "Nastavení"
            image_name = "icon_settings"
        }
        else {
            name = "O aplikaci"
            image_name = "icon_about"
        }
        cell.configureCell(name: name, image_name: image_name)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        if data.type == .settings {
            let settingsViewController = SettingsTableViewController()
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
        else {
            let aboutViewController = AboutViewController()
            navigationController?.pushViewController(aboutViewController, animated: true)
        }
    }

  
    private func loadRowData() {
        rowData.append(RowData(type: .settings, desatek: nil))
        rowData.append(RowData(type: .about, desatek: nil))
    }
}

