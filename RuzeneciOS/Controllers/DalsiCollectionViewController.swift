//
//  DalsiCollectionViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 01.10.2026.
//  Copyright © 2026 Petr Hracek. All rights reserved.
//

import UIKit
import os.log
import FirebaseAnalytics

class JineCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
        var name: String = ""
        var image_name: String = ""
        name = data.desatek!.name
        image_name = data.desatek!.photo
        cell.configureCell(name: name, image_name: image_name)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

    //MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        if indexPath.row == RosaryConstants.pompej.rawValue {
            let pompejViewController = PompejViewController()
            navigationController?.pushViewController(pompejViewController, animated: true)
        }
        else {
            let ruzenecViewController = RuzenecViewController()
            if let selectedDesatek = rowData[indexPath.row].desatek {
                ruzenecViewController.desatek = selectedDesatek
                ruzenecViewController.navigationItem.title = selectedDesatek.name
            }
            navigationController?.pushViewController(ruzenecViewController, animated: true)
        }
    }

    private func loadDesatky() {
        let photoSedmibolestny = "icon_sorrow"
        let photoFrantisekSedmi = "icon_frantisek"
        let photoJoseph = "icon_joseph"
        let photoSedmiradostna = "icon_mary"
        let photoOtecPio = "icon_otecPio"
        let photoPompej = "icon_pompej"
        
        guard let pompejska_novena = Desatek(name: "Pompejská novéna", photo: photoPompej, desatek: RosaryConstants.pompej.rawValue) else {
            fatalError("Unable to instanciate pompej novena")
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
        
        guard let otec_pio = Desatek(name: "Růženec otce Pia", photo: photoOtecPio, desatek: RosaryConstants.otecPio.rawValue) else {
            fatalError("Unable to instanciate pompej novena")
        }
        
        desatky += [sedmibolestne,
                    sedmiradostne, frantiskanskysedmibolestny, frantiskanskysedmiradostny, sv_josef, otec_pio, pompejska_novena]
    }
    
    private func loadRowData() {
        rowData = desatky.map { RowData(type: .desatek, desatek: $0) }
    }
}

