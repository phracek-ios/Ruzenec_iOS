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
    }
    
    struct RowData {
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
        loadDesatky()
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
        let name = data.desatek!.name
        let image_name = data.desatek!.photo
        cell.configureCell(name: name, image_name: image_name)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }

    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        let ruzenecViewController = BasicRuzenecViewController()
        print(data.desatek?.desatek)
        print(Date().getDayOfWeek())
        if data.desatek?.desatek == RosaryConstants.dnes.rawValue {
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
    }

    private func loadDesatky() {
        let photoCalendar = "icon_calendar"
        let photoRadostny = "icon_radostny"
        let photoBolestny = "icon_bolestny"
        let photoSvetla = "icon_svetla"
        let photoSlavny = "icon_slavny"
        let photoKorunka = "icon_korunka"

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

        
        desatky = [calendar, radostny, bolestny, svetla, slavny, korunka]
    }
    
    private func loadRowData() {
        for desatek in desatky {
            rowData.append(RowData(desatek: desatek))
        }
        print("JineCollectionViewController(loadRowData): \(rowData)")
    }
}

extension Date {
    func getDayOfWeek() -> Int {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        switch weekDay {
        case 1: // Sun - Slavny
            return RosaryConstants.slavny.rawValue
        case 2: // Mon - Radostny
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
