//
//  RuzenecViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 06/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot

var statusBarIsHidden = true
class RuzenecViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var ruzenec_text_contain: UILabel!
    @IBOutlet weak var ruzenec_image: UIImageView!
    @IBOutlet weak var next_button: UIButton!
    @IBOutlet var rosary_view_controller: UIView!
    @IBOutlet weak var previous_button: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        self.scrollView.delegate = self
        self.view.isUserInteractionEnabled = true
        ruzenec_text_contain.numberOfLines = 0
        
        rosaryStructure = RosaryDataService.shared.rosaryStructure
        let userDefaults = UserDefaults.standard
        darkMode = userDefaults.bool(forKey: "NightSwitch")
        enabledDarkMode()
        setupUI()
        if let desatek = desatek {
            navigationController?.title = desatek.name
            if darkMode {
                navigationController?.navigationBar.tintColor = KKCTextNightMode
            }
            else {
                navigationController?.navigationBar.tintColor = KKCTextLightMode
            }
            navigationController?.navigationBar.barTintColor = KKCMainColor
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
            navigationController?.navigationBar.barStyle = UIBarStyle.black;

            self.zdravas_number = desatek.desatek
            if self.zdravas_number == RosaryConstants.korunka.rawValue {
                typ_obrazku = "m"
            }
            else {
                if self.zdravas_number == RosaryConstants.sedmiradostne.rawValue {
                   typ_obrazku = "s"
                }
                else if self.zdravas_number == RosaryConstants.sedmibolestne.rawValue {
                   typ_obrazku = "s"
                }
            }
            show_texts(by: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
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

        switch count {
        case rn.credo:
            ruzenec_text_contain.attributedText = get_html_text(text: "\(rosaryStructure.inNominePatri)\n\(rosaryStructure.credo)")
            previous_button.isEnabled = false
        case rn.lord:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.lordPrayer)
            previous_button.isEnabled = true
        case rn.salveReginaFirst:
            ruzenec_text_contain.attributedText = get_html_text(text: "v kterého věříme", kindForGeneration: 1)
        case rn.salveReginaSecond:
            ruzenec_text_contain.attributedText = get_html_text(text: "v kterého doufáme", kindForGeneration: 1)
        case rn.salveReginaThird:
            ruzenec_text_contain.attributedText = get_html_text(text: "kterého nade všechno milujeme", kindForGeneration: 1)
        case rn.meaCulpa:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.gloriaPatri)
        default:
            ruzenec_text_contain.text = "Error"
        }
    }

    func show_ruzenec_sedmi_text(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        switch count {
        case rsn.lordOne, rsn.lordTwo, rsn.lordThree, rsn.lordFour, rsn.lordFive, rsn.lordSix, rsn.lordSeven:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.lordPrayer)
        case rsn.rosaryOne..<(rsn.meaCulpaOne-1), rsn.rosaryTwo..<(rsn.meaCulpaTwo-1),
             rsn.rosaryThree..<(rsn.meaCulpaThree-1), rsn.rosaryFour..<(rsn.meaCulpaFour-1),
             rsn.rosaryFive..<(rsn.meaCulpaFive-1), rsn.rosarySix..<(rsn.meaCulpaSix-1),
             rsn.rosarySeven..<(rsn.meaCulpaSeven-1):
            let rosary = rosaryStructure.rosaries[self.zdravas_number - 2]
            let secret = rosary.decades[self.type_desatek]
            ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
        case rsn.meaCulpaOne - 1, rsn.meaCulpaTwo - 1, rsn.meaCulpaThree - 1,
             rsn.meaCulpaFour - 1, rsn.meaCulpaFive - 1,
             rsn.meaCulpaSix - 1, rsn.meaCulpaSeven - 1:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.gloriaPatri)
        case rsn.meaCulpaOne, rsn.meaCulpaTwo, rsn.meaCulpaThree, rsn.meaCulpaFour, rsn.meaCulpaFive, rsn.meaCulpaSix:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.meaCulpa)
            if direction {
                self.type_desatek += 1
            }
            else {
                self.type_desatek -= 1
            }
        case rsn.meaCulpaSeven:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.meaCulpa)
            next_button.isEnabled = true
        case rsn.salveRegina:
            if self.zdravas_number == 7 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.salveRegina)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.painRedeem)
            }
            if self.zdravas_number == 6 {
                next_button.isEnabled = true
            }
        case rsn.pray, rsn.painReedem:
            if self.zdravas_number == 7 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.pray)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.painEnd)
            }
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    
    func show_ruzenec_text(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }

        switch count {
        case rn.lordFirst, rn.lordSecond, rn.lordThird, rn.lordFourth, rn.lordFifth:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.lordPrayer)
        case rn.rosaryFirst..<(rn.meaCulpaFirst-1), rn.rosarySecond..<(rn.meaCulpaSecond-1),
             rn.rosaryThird..<(rn.meaCulpaThird-1), rn.rosaryFourth..<(rn.meaCulpaFourth-1),
             rn.rosaryFifth..<(rn.meaCulpaFifth-1):
            if self.zdravas_number == 8 {
                let rosary = rosaryStructure.rosaries[self.zdravas_number - 2]
                let secret = rosary.decades[self.type_desatek]
                ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
            }
            else {
                let rosary = rosaryStructure.rosaries[self.zdravas_number - 1]
                let secret = rosary.decades[self.type_desatek]
                ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
            }
        case rn.meaCulpaFirst - 1, rn.meaCulpaSecond - 1, rn.meaCulpaThird - 1, rn.meaCulpaFourth - 1, rn.meaCulpaFifth - 1:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.gloriaPatri)
        case rn.meaCulpaFirst, rn.meaCulpaSecond, rn.meaCulpaThird, rn.meaCulpaFourth, rn.meaCulpaFifth:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.meaCulpa)
            if count < rn.meaCulpaFifth {
                if direction {
                    self.type_desatek += 1
                }
                else {
                    self.type_desatek -= 1
                }
            }
        case rn.salveRegina:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.salveRegina)
            next_button.isEnabled = true
        case rn.pray:
            if self.zdravas_number == 8 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.prayJosef)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.pray)
            }
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    
    func show_korunka(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        
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
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.korunka_end)
            next_button.isEnabled = true
        case crown.saintThree:
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
        show_image(by: direction)
        handle_counter(by: direction)
        handle_image_counter(by: direction)
        if self.zdravas_number == RosaryConstants.korunka.rawValue{
            show_korunka(by: direction)
        }
        else {
            if count < 7 {
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
        self.ruzenec_text_contain.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.ruzenec_text_contain.textAlignment = .center

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
            self.view.backgroundColor = KKCBackgroundNightMode
            self.ruzenec_text_contain.backgroundColor = KKCBackgroundNightMode
            self.ruzenec_text_contain.textColor = KKCTextNightMode
        }
        else {
            self.view.backgroundColor = KKCBackgroundLightMode
            self.ruzenec_text_contain.backgroundColor = KKCBackgroundLightMode
            self.ruzenec_text_contain.textColor = KKCTextLightMode
        }

    }

    private func get_html_text(text: String, kindForGeneration: Int = 0) -> NSAttributedString {
        guard let rosaryStructure = rosaryStructure else { return NSAttributedString() }
        var main_text: String = ""
        if kindForGeneration == 0 {
            main_text = text
        }
        else if kindForGeneration == 1 {
            main_text = "\(rosaryStructure.aveMaria)<red>\(text)</red>\(rosaryStructure.aveMariaEnd)"
        }

        return generateContent(text: main_text, darkMode: self.darkMode)
    }
}

private extension RuzenecViewController {
    func setupUI() {
        ruzenec_text_contain.textAlignment = .center
    }
}
