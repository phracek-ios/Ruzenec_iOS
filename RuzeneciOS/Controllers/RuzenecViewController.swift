//
//  RuzenecViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 06/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot

class RuzenecViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var ruzenec_text_contain: UILabel!
    @IBOutlet weak var ruzenec_image: UIImageView!
    @IBOutlet weak var next_button: UIButton!
    @IBOutlet var rosary_view_controller: UIView!
    @IBOutlet weak var previous_button: UIButton!
    var count: Int = 0
    var image_count: Int = 0
    var type_desatek: Int = 0
    var zdravas_number: Int = 0

    var zrno: Int = 0
    var desatek: Desatek?
    var typ_obrazku: String = "r"
    var darkMode: Bool = true
    fileprivate var rosaryStructure: RosaryStructure?
    var rn = RosaryNumbers.init()
    var rsn = RosarySevenNumbers.init()
    var crown = Crown.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTappedGesture))
        self.view.addGestureRecognizer(tapGesture)
        ruzenec_text_contain.addGestureRecognizer(tapGesture)
        ruzenec_image.addGestureRecognizer(tapGesture)
        ruzenec_text_contain.numberOfLines = 0
        
        rosaryStructure = RosaryDataService.shared.rosaryStructure
        let userDefaults = UserDefaults.standard
        darkMode = userDefaults.bool(forKey: "NightSwitch")
        enabledDarkMode()
        setupUI()
        if let desatek = desatek {
            self.navigationController?.title = desatek.name
            self.zdravas_number = desatek.desatek
            if self.zdravas_number == RosaryConstants.korunka.rawValue {
                typ_obrazku = "m"
                show_korunka(by: true)
            }	
            else {
                if self.zdravas_number == RosaryConstants.sedmibolestne.rawValue {
                   typ_obrazku = "s"
                }
                else if self.zdravas_number == RosaryConstants.sedmiradostne.rawValue {
                   typ_obrazku = "s"
                }
                show_ruzenec_zacatek(by: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        //UIApplication.shared.isStatusBarHidden = false
    }
    
    func show_image (by direction: Bool) {
        if direction {
            ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count + 1))
        }
        else {
            ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count - 1))
        }
    }
    
    func handle_counter (by direction: Bool) {
        if direction {
            count += 1
        }
        else {
            count -= 1
        }
    }
    
    func handle_image_counter(by direction: Bool) {
        if direction {
            image_count += 1
        }
        else {
            image_count -= 1
        }
    }
    func show_ruzenec_zacatek(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        
        show_image(by: direction)
        handle_counter(by: direction)
        handle_image_counter(by: direction)
        switch count {
        case 1:
            ruzenec_text_contain.text = rosaryStructure.inNominePatri + "\n" + rosaryStructure.credo
            previous_button.isEnabled = false
        case 2:
            ruzenec_text_contain.text = rosaryStructure.lordPrayer
            previous_button.isEnabled = true
        case 3:
            ruzenec_text_contain.attributedText = get_html_text(text: "v kterého věříme.", kindForGeneration: 1)
        case 4:
            ruzenec_text_contain.attributedText = get_html_text(text: "v kterého doufáme.", kindForGeneration: 1)
        case 5:
            ruzenec_text_contain.attributedText = get_html_text(text: "v kterého nade všechno milujeme.", kindForGeneration: 1)
        case 6:
            ruzenec_text_contain.text = rosaryStructure.gloriaPatri
        default:
            ruzenec_text_contain.text = "Error"
        }
    }

    func show_ruzenec_sedmi_text(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        
        show_image(by: direction)
        handle_counter(by: direction)
        handle_image_counter(by: direction)
        print(image_count)
        switch count {
        case rsn.lordOne, rsn.lordTwo, rsn.lordThree, rsn.lordFour, rsn.lordFive, rsn.lordSix, rsn.lordSeven:
            ruzenec_text_contain.text = rosaryStructure.lordPrayer
        case rsn.rosaryOne...(rsn.lordTwo-3), rsn.rosaryTwo...(rsn.lordThree-3),
             rsn.rosaryThree...(rsn.lordFour-3), rsn.rosaryFour...(rsn.lordFive-3),
             rsn.rosaryFive...(rsn.lordSix-3), rsn.rosarySix...(rsn.lordSeven-3),
             rsn.rosarySeven...(rsn.meaCulpaSeven-2):
            let rosary = rosaryStructure.rosaries[self.zdravas_number - 1]
            let secret = rosary.decades[self.type_desatek]
            ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
        case rsn.meaCulpaOne - 1, rsn.meaCulpaTwo - 1, rsn.meaCulpaThree - 1,
             rsn.meaCulpaFour - 1, rsn.meaCulpaFive - 1,
             rsn.meaCulpaSix - 1, rsn.meaCulpaSeven - 1:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.gloriaPatri)
        case rsn.meaCulpaOne, rsn.meaCulpaTwo, rsn.meaCulpaThree, rsn.meaCulpaFour, rsn.meaCulpaFive, rsn.meaCulpaSix:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.oMyLord)
        case rsn.meaCulpaSeven:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.oMyLord)
        case rsn.salveRegina:
            image_count = 74
            if self.zdravas_number == 7 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.painRedeem)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.painEnd)
            }

            next_button.isEnabled = true
            if direction {
                self.image_count -= 1
            }
            else {
                self.image_count += 1
            }
        case rsn.pray:
            image_count = 74
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.pray)
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    
    func show_ruzenec_text(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        show_image(by: direction)
        handle_counter(by: direction)
        handle_image_counter(by: direction)
        switch count {
        case rn.lordFirst, rn.lordSecond, rn.lordThird, rn.lordFourth, rn.lordFifth:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.lordPrayer)
        case rn.rosaryFirst...(rn.lordSecond-3), rn.rosarySecond...(rn.lordThird-3),
             rn.rosaryThird...(rn.lordFourth-3), rn.rosaryFourth...(rn.lordFifth-3),
             rn.rosaryFifth...(rn.meaCulpaFifth-2):
            let rosary = rosaryStructure.rosaries[self.zdravas_number - 1]
            let secret = rosary.decades[self.type_desatek]
            ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
        case rn.meaCulpaFirst - 1, rn.meaCulpaSecond - 1, rn.meaCulpaThird - 1, rn.meaCulpaFourth - 1, rn.meaCulpaFifth - 1:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.gloriaPatri)
            if direction {
                self.image_count -= 1
            }
            else {
                self.image_count += 1
            }
        case rn.meaCulpaFirst, rn.meaCulpaSecond, rn.meaCulpaThird, rn.meaCulpaFourth:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.meaCulpa)
            self.type_desatek += 1
        case rn.meaCulpaFifth:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.meaCulpa)
            if direction {
                self.image_count -= 1
            }
            else {
                self.image_count += 1
            }
        case rn.salveRegina:
            image_count = 66
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.salveRegina)
            next_button.isEnabled = true
            if direction {
                self.image_count -= 1
            }
            else {
                self.image_count += 1
            }
        case rn.pray:
            image_count = 66
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.pray)
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    
    
    @IBAction func viewTappedGesture(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UIView
        let newView = UIView(frame: view.frame)
        newView.frame = UIScreen.main.bounds
        newView.contentMode = .scaleToFill
        newView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenView))
        newView.addGestureRecognizer(tap)
        self.view.addSubview(newView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        //UIApplication.shared.isStatusBarHidden = true
        //setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func dismissFullscreenView(_ sender: UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        //UIApplication.shared.isStatusBarHidden = false
        //setNeedsStatusBarAppearanceUpdate()
        sender.view?.removeFromSuperview()
    }

    func show_korunka(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        
        show_image(by: direction)
        handle_counter(by: direction)
        handle_image_counter(by: direction)
        switch count {
        case crown.lord:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.lordPrayer)
            previous_button.isEnabled = false
        case crown.salve:
            previous_button.isEnabled = true
            ruzenec_text_contain.attributedText = get_html_text(text: "\(rosaryStructure.aveMaria)\(rosaryStructure.aveMariaEnd)")
        case crown.credo:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.credo)
        case crown.crownOne, crown.crownTwo, crown.crownThree, crown.crownFour, crown.crownFive:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.korunka_main)
        case crown.smallCrownOne...(crown.crownTwo - 1), crown.smallCrownTwo...(crown.crownThree - 1),
             crown.smallCrownThree...(crown.crownFour - 1), crown.smallCrownFour...(crown.crownFive - 1),
             crown.smallCrownFive...(crown.saintOne - 1):
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.korunka_rosary)
        case crown.saintOne, crown.saintTwo:
            image_count = 59
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.korunka_end)
            next_button.isEnabled = true
            if direction {
                self.image_count -= 1
            }
            else {
                self.image_count += 1
            }
        case crown.saintThree:
            image_count = 59
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.korunka_end)
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }

    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Actions
    
    func show_texts(by direction: Bool) {
        if self.zdravas_number == RosaryConstants.korunka.rawValue{
            show_korunka(by: direction)
        }
        else {
            if count < 6 {
                show_ruzenec_zacatek(by: direction)
            }
            else {
                if self.zdravas_number == RosaryConstants.sedmiradostne.rawValue {
                    show_ruzenec_sedmi_text(by: direction)
                }
                else if self.zdravas_number == RosaryConstants.sedmibolestne.rawValue {
                    show_ruzenec_sedmi_text(by: direction)
                }
                else {
                    show_ruzenec_text(by: direction)
                }
            }
        }

    }
    @IBAction func previous_button(_ sender: UIButton) {
        enabledDarkMode()
        show_texts(by: false)
    }

    @IBAction func next_button(_ sender: UIButton) {
        enabledDarkMode()
        show_texts(by: true)
    }
        
    func enabledDarkMode() {
        if darkMode == true {
            self.view.backgroundColor = UIColor.black
            self.ruzenec_text_contain.backgroundColor = UIColor.black
            self.ruzenec_text_contain.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            self.ruzenec_text_contain.backgroundColor = UIColor.white
            self.ruzenec_text_contain.textColor = UIColor.black
        }

    }

    private func get_html_text(text: String, kindForGeneration: Int = 0) -> NSAttributedString {
        guard let rosaryStructure = rosaryStructure else { return NSAttributedString() }
        var main_text: String = ""
        if kindForGeneration == 0 {
            main_text = "\(rosaryStructure.aveMaria)<red>\(text)</red>\(rosaryStructure.aveMariaEnd)"
        }
        else if kindForGeneration == 1 {
            main_text = text
        }
        return generateContent(text: main_text)
    }
}

private extension RuzenecViewController {
    func setupUI() {
        ruzenec_text_contain.textAlignment = .center
    }
}
