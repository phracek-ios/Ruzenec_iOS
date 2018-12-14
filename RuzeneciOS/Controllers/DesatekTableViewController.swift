//
//  DesatekTableViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 15/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import os.log

class DesatekTableViewController: UITableViewController {
    
    enum RowType {
        case desatek
        case settings
        case about
    }
    
    struct RowData {
        let type: RowType
        let desatek: Desatek?
    }

    //MARK: Properties
    
    fileprivate var desatky = [Desatek]()
    fileprivate var rowData = [RowData]()
    fileprivate var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load sample data
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
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
        }
        else {
            self.view.backgroundColor = KKCBackgroundLightMode
        }
        self.tableView.tableFooterView = UIView()
        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DesatekTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DesatekTableViewCell else {
            fatalError("The dequeue cell is not an entrance of DesatekTableViewCell")
        }
        let data = rowData[indexPath.row]
        switch data.type {
        case .desatek:
            cell.desatekLabel.text = data.desatek?.name
            cell.photoImageView.image = data.desatek?.photo
        case .settings:
            cell.desatekLabel.text = "Nastavení"
            cell.photoImageView.image = UIImage(named: "icon_settings")
        case .about:
            cell.desatekLabel.text = "O aplikaci"
            cell.photoImageView.image = UIImage(named: "icon_about")
        }
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
            cell.desatekLabel.textColor = KKCTextNightMode
        }
        else {
            cell.backgroundColor = KKCBackgroundLightMode
            cell.desatekLabel.textColor = KKCTextLightMode
        }
        return cell
    }
    

    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowRuzenec":
            guard let ruzenecDetailViewController = segue.destination as? RuzenecViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if indexPath.row == RosaryConstants.dnes.rawValue {
                ruzenecDetailViewController.desatek = rowData[Date().getDayOfWeek()].desatek
                ruzenecDetailViewController.navigationItem.title = rowData[Date().getDayOfWeek()].desatek?.name
            }
            else {
                if let selectedDesatek = rowData[indexPath.row].desatek {
                    ruzenecDetailViewController.desatek = selectedDesatek
                    ruzenecDetailViewController.navigationItem.title = selectedDesatek.name
                }
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let data = rowData[indexPath.row]
        
        switch data.type {
        
        case .desatek:
            performSegue(withIdentifier: "ShowRuzenec", sender: indexPath)
        case .settings:
            //let settingsViewController = SettingsViewController()
            //navigationController?.pushViewController(settingsViewController, animated: true)
            if let settingsViewController = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(settingsViewController, animated: true)
            }
        case .about:
            if let aboutViewController = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(aboutViewController, animated: true)
            }
        default:
            fatalError("Unexpected raw")
        }
        
    }

    private func loadDesatky() {
        let photoCalendar = UIImage(named: "icon_calendar")
        let photoRadostny = UIImage(named: "icon_radostny")
        let photoBolestny = UIImage(named: "icon_bolestny")
        let photoSvetla = UIImage(named: "icon_svetla")
        let photoSlavny = UIImage(named: "icon_slavny")
        let photoKorunka = UIImage(named: "icon_korunka")
        let photoSedmibolestny = UIImage(named: "icon_sorrow")
        let photoJoseph = UIImage(named: "icon_joseph")
        let photoSedmiradostna = UIImage(named: "icon_mary")

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
        self.tableView.backgroundColor = KKCBackgroundNightMode
        self.tableView.reloadData()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.tableView.backgroundColor = KKCBackgroundLightMode
        self.tableView.reloadData()
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
