//
//  DesatekCollectionViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 15/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import os.log
import FirebaseAnalytics

class DesatekCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
    
    fileprivate var desatky = [Desatek]()
    fileprivate var rowData = [RowData]()
    fileprivate var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Seznam desatku",
                                       AnalyticsParameterScreenClass: className])
        loadDesatky()
        loadRowData()
        let userDefaults = UserDefaults.standard
        let dimmOff = userDefaults.bool(forKey: "DimmScreen")
        if dimmOff == true {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        setupCollectionView()

        navigationItem.title = "Růženec"

        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
//        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
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
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesatekCollectionViewCell.cellId, for: indexPath) as! DesatekCollectionViewCell
        let data = rowData[indexPath.row]
        var name: String = ""
        var image_name: String = ""
        switch data.type {
        case .desatek:
            name = data.desatek!.name
            image_name = data.desatek!.photo
        case .settings:
            name = "Nastavení"
            image_name = "icon_settings"
        case .about:
            name = "O aplikaci"
            image_name = "icon_about"
        }
        cell.configureCell(name: name, image_name: image_name)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]

        switch data.type {

        case .desatek:
            let ruzenecViewController = RuzenecViewController()
            if indexPath.row == RosaryConstants.dnes.rawValue {
                ruzenecViewController.desatek = rowData[Date().getDayOfWeek()].desatek
                ruzenecViewController.navigationItem.title = rowData[Date().getDayOfWeek()].desatek?.name
            }
            else {
                if let selectedDesatek = rowData[indexPath.row].desatek {
                    ruzenecViewController.desatek = selectedDesatek
                    ruzenecViewController.navigationItem.title = selectedDesatek.name
                }
            }
            navigationController?.pushViewController(ruzenecViewController, animated: true)
        case .settings:
            let settingsViewController = SettingsTableViewController()
            navigationController?.pushViewController(settingsViewController, animated: true)
        case .about:
            let aboutViewController = AboutViewController()
            navigationController?.pushViewController(aboutViewController, animated: true)
        }
    }

    private func loadDesatky() {
        let photoCalendar = "icon_calendar"
        let photoRadostny = "icon_radostny"
        let photoBolestny = "icon_bolestny"
        let photoSvetla = "icon_svetla"
        let photoSlavny = "icon_slavny"
        let photoKorunka = "icon_korunka"
        let photoSedmibolestny = "icon_sorrow"
        let photoJoseph = "icon_joseph"
        let photoSedmiradostna = "icon_mary"

        guard let calendar = Desatek(name: "Růženec na dnešní den", photo: photoCalendar, desatek: RosaryConstants.dnes.rawValue) else {
            fatalError("Unable to instanciate Ruzenec")
        }

        guard let radostny = Desatek(name: "Radostný růženec", photo: photoRadostny, desatek: RosaryConstants.radostny.rawValue) else {
            fatalError("Unable to instanciate Radostny ruzenec")
        }
        
        guard let bolestny = Desatek(name: "Bolestný růženec", photo: photoBolestny, desatek: RosaryConstants.bolestny.rawValue) else {
            fatalError("Unable to instanciate bolestny ruzenec")
        }
        
        guard let svetla = Desatek(name: "Růženec světla", photo: photoSvetla, desatek: RosaryConstants.svetla.rawValue) else {
            fatalError("Unable to instanciate ruzenec svetla")
        }
        
        guard let slavny = Desatek(name: "Slavný růženec", photo: photoSlavny, desatek: RosaryConstants.slavny.rawValue) else {
            fatalError("Unable to instanciate slavny ruzenec")
        }
        
        guard let korunka = Desatek(name: "Korunka k Božímu milosrdenství", photo: photoKorunka, desatek: RosaryConstants.korunka.rawValue) else {
            fatalError("Unable to instanciate r3")
        }
        guard let sedmibolestne =  Desatek(name: "Sedmibolestná tajemství", photo: photoSedmibolestny, desatek: RosaryConstants.sedmibolestne.rawValue) else {
            fatalError("Unable to instanciate sedmiradostny ruzenec")
        }
        
        guard let sedmiradostne = Desatek(name: "Sedmiradostná tajemství", photo: photoSedmiradostna, desatek: RosaryConstants.sedmiradostne.rawValue) else {
            fatalError("Unable to instanciate sedmiradostny")
        }
        
        guard let sv_josef = Desatek(name: "Růženec ke sv. Josefovi", photo: photoJoseph, desatek: RosaryConstants.sv_Josef.rawValue) else {
            fatalError("Unable to instanciate ruzenec sv josefa")
            
        }
        
        desatky += [calendar, radostny, bolestny, svetla, slavny, korunka, sedmibolestne,
        sedmiradostne, sv_josef]
    }
    
    private func loadRowData() {
        rowData = desatky.map { RowData(type: .desatek, desatek: $0) }
        rowData.append(RowData(type: .settings, desatek: nil))
        rowData.append(RowData(type: .about, desatek: nil))
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.collectionView!.backgroundColor = KKCBackgroundNightMode
        //self.tableView.reloadData()
    }

    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.collectionView!.backgroundColor = KKCBackgroundLightMode
        //self.tableView.reloadData()
    }
}

extension Date {
    func getDayOfWeek() -> Int {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        switch weekDay {
        case 1: // Sun - Slavny
            return RosaryConstants.slavny.rawValue
        case 2: // Mon - Radostny
            print("Radostny")
            return RosaryConstants.radostny.rawValue
        case 3: // Tue - Bolestny
            return RosaryConstants.bolestny.rawValue
        case 4: // Wed - Slavny
            return RosaryConstants.slavny.rawValue
        case 5: // Thu - Svetla
            return RosaryConstants.svetla.rawValue
        case 6: // Fri - Bolestny
            return RosaryConstants.bolestny.rawValue
        case 7: // Sat - Radostny
            return RosaryConstants.radostny.rawValue
        default:
            print("Error fetching days")
            return -1
        }
    }
}
