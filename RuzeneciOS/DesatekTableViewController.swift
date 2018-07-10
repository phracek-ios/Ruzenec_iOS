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

    //MARK: Properties
    
    var desatky = [Desatek]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load sample data
        loadDesatky()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return desatky.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DesatekTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DesatekTableViewCell else {
            fatalError("The dequeue cell is not an entrance of DesatekTableViewCell")
        }
        let des = desatky[indexPath.row]
        cell.desatekLabel.text = des.name
        cell.photoImageView.image = des.photo

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowDetail":
            guard let ruzenecDetailViewController = segue.destination as? RuzenecViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedDesatekCell = sender as? DesatekTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedDesatekCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedDesatek = desatky[indexPath.row]
            ruzenecDetailViewController.desatek = selectedDesatek
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
    


    private func loadDesatky() {
        let photoRadostny = UIImage(named: "icon_radostny")
        let photoBolestny = UIImage(named: "icon_bolestny")
        let photoSvetla = UIImage(named: "icon_svetla")
        let photoSlavny = UIImage(named: "icon_slavny")
        let photoKorunka = UIImage(named: "icon_korunka")
        let photoNastaveni = UIImage(named: "icon_settings")
        let photoO_aplikaci = UIImage(named: "icon_about")
        
        guard let radostny = Desatek(name: "Radostny ruzenec", photo: photoRadostny, desatek: 0) else {
            fatalError("Unable to instanciate Radostny ruzenec")
            
        }
        
        guard let bolestny = Desatek(name: "Bolestny ruzenec", photo: photoBolestny, desatek: 1) else {
            fatalError("Unable to instanciate bolestny ruzenec")
        }
        
        guard let svetla = Desatek(name: "Ruzenec Svetla", photo: photoSvetla, desatek: 2) else {
            fatalError("Unable to instanciate ruzenec svetla")
        }
        
        guard let slavny = Desatek(name: "Slavny ruzenec", photo: photoSlavny, desatek: 3) else {
            fatalError("Unable to instanciate slavny ruzenec")
        }
        
        guard let korunka = Desatek(name: "Korunka k Bozimu milosrdenstvi", photo: photoKorunka, desatek: 4) else {
            fatalError("Unable to instanciate r3")
        }
        
        guard let nastaveni = Desatek(name: "Nastaveni", photo: photoNastaveni, desatek: 5) else {
            fatalError("Unable to instanciate nastaveni")
        }
        guard let o_aplikaci = Desatek(name: "O aplikaci", photo: photoO_aplikaci, desatek: 6) else {
            fatalError("Unable to instanciate o aplikaci")
        }
        desatky += [radostny, bolestny, svetla, slavny, korunka, nastaveni, o_aplikaci]
    }
}
