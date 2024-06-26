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
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self

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

        navigationItem.title = "Růženec"

        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
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
        return CGSize(width: view.frame.width, height: 80)
    }

    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        switch data.type {

        case .desatek:
            if indexPath.row == RosaryConstants.pompej.rawValue {
                let pompejViewController = PompejViewController()
                navigationController?.pushViewController(pompejViewController, animated: true)
            }
            else if indexPath.row == RosaryConstants.otecPio.rawValue {
                let otecPioVC = OtecPioZacatekViewController()
                if let selectedDesatek = rowData[Date().getDayOfWeek()].desatek {
                    otecPioVC.desatek = selectedDesatek
                    otecPioVC.navigationItem.title = selectedDesatek.name
                }
                navigationController?.pushViewController(otecPioVC, animated: true)
            }
            else if (indexPath.row == RosaryConstants.frantiseksedmibolestne.rawValue) || (indexPath.row == RosaryConstants.frantiseksedmiradostne.rawValue){
                let frantiskanskyVC = FrantiskanskyRuzenecViewController()
                if let selectedDesatek = rowData[indexPath.row].desatek {
                    frantiskanskyVC.desatek = selectedDesatek
                    frantiskanskyVC.navigationItem.title = selectedDesatek.name
                }
                navigationController?.pushViewController(frantiskanskyVC, animated: true)
            }
            else {
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
            }
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
        let photoFrantisekSedmi = "icon_frantisek"
        let photoJoseph = "icon_joseph"
        let photoSedmiradostna = "icon_mary"
        let photoPompej = "icon_pompej"
        let photoOtecPio = "icon_otecPio"

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
        guard let frantiskanskysedmiradostny =  Desatek(name: "Františkánský sedmiradostný růženec", photo: photoFrantisekSedmi, desatek: RosaryConstants.frantiseksedmiradostne.rawValue) else {
            fatalError("Unable to instanciate sedmiradostny ruzenec")
        }
        
        guard let frantiskanskysedmibolestny = Desatek(name: "Františkánský sedmibolestný růženec", photo: photoFrantisekSedmi, desatek: RosaryConstants.frantiseksedmibolestne.rawValue) else {
            fatalError("Unable to instanciate sedmiradostny")
        }
        
        guard let sv_josef = Desatek(name: "Růženec ke sv. Josefovi", photo: photoJoseph, desatek: RosaryConstants.sv_Josef.rawValue) else {
            fatalError("Unable to instanciate ruzenec sv josefa")
            
        }
        
        guard let pompejska_novena = Desatek(name: "Pompejská novéna", photo: photoPompej, desatek: RosaryConstants.pompej.rawValue) else {
            fatalError("Unable to instanciate pompej novena")
        }
        
        guard let otec_pio = Desatek(name: "Růženec otce Pia", photo: photoOtecPio, desatek: RosaryConstants.otecPio.rawValue) else {
            fatalError("Unable to instanciate pompej novena")
        }
        
        desatky += [calendar, radostny, bolestny, svetla, slavny, korunka, sedmibolestne,
        sedmiradostne, frantiskanskysedmibolestny, frantiskanskysedmiradostny, sv_josef, pompejska_novena, otec_pio]
    }
    
    private func loadRowData() {
        rowData = desatky.map { RowData(type: .desatek, desatek: $0) }
        rowData.append(RowData(type: .settings, desatek: nil))
        rowData.append(RowData(type: .about, desatek: nil))
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
