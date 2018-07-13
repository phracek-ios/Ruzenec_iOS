//
//  SettingsViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var night_light: UISwitch!
    @IBOutlet weak var turn_off_sound: UISwitch!
    fileprivate var original_volume: Float = 0.0
    
    @IBAction func OnOffRing(_ sender: Any) {
        //let session = AVAudioSession.sharedInstance()
        if turn_off_sound.isOn {
            var value = original_volume
        }
        else {

            var volume: Float = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
