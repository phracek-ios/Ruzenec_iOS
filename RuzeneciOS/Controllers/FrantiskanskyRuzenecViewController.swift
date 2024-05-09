//
//  FrantiskanskyRuzenecViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 30.04.2024.
//  Copyright © 2024 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import BonMot
import AVFoundation
import CallKit

// http://www.farnost-vlachovo-brezi.cz/cs/modlitby/ruzenec-otce-pia/
class FrantiskanskyRuzenecViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    lazy var ruzenec_text_contain: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var ruzenec_image: UIImageView = {
        let ri = UIImageView()
        ri.translatesAutoresizingMaskIntoConstraints = false
        ri.sizeToFit()
        return ri
    }()

    lazy var next_button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Další", for: .normal)
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()

    lazy var previous_button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Předchozí", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(previousAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var play_button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var scrollViewContainer: UIStackView = {
        let svc = UIStackView()
        svc.translatesAutoresizingMaskIntoConstraints = false
        return svc
    }()
    
    lazy var btnViewContainer: UIStackView = {
        let bvc = UIStackView()
        bvc.translatesAutoresizingMaskIntoConstraints = false
        return bvc
    }()
    
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    var count: Int = 0
    var image_count: Int = 0
    var type_desatek: Int = 0
    var zdravas_number: Int = 0
    var speak: Bool = false
    var zrno: Int = 0
    var desatek: Desatek?
    var typ_obrazku: String = "f"
    var darkMode: Bool = true
    fileprivate var rosaryStructure: RosaryStructure?
    fileprivate var rosarySpeakStructure: RosarySpeakStructure?
    var rn = RosaryFrantisekNumbers.init()
    var crown = Crown.init()
    var font_name: String = "Helvetica"
    var font_size: String = "16"
    let synthesizer = AVSpeechSynthesizer()
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var callObserver = CXCallObserver()
    
    var isStatusBarHidden = false {
        didSet {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.scrollView.delegate = self
        self.view.isUserInteractionEnabled = true
        ruzenec_text_contain.numberOfLines = 0

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rosaryStructure = RosaryDataService.shared.rosaryStructure
        rosarySpeakStructure = RosaryDataService.shared.rosarySpeakStructure
        let userDefaults = UserDefaults.standard
        callObserver.setDelegate(self, queue: nil)
        speak = false
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
            if userDefaults.bool(forKey: keys.serifEnabled) {
                self.font_name = "Times New Roman"
            } else {
                userDefaults.set(true, forKey: keys.serifEnabled)
                self.font_name = "Helvetica"
            }
            
            if let saveFontSize = userDefaults.string(forKey: keys.fontSize) {
                self.font_size = saveFontSize
            } else {
                userDefaults.set(16, forKey: keys.fontSize)
                self.font_size = "16"
            }
            darkMode = userDefaults.bool(forKey: keys.night)
            if darkMode == true {
                self.back = KKCBackgroundNightMode
                self.text = KKCTextNightMode
            }
            else {
                self.back = KKCBackgroundLightMode
                self.text = KKCTextLightMode
            }
             self.zdravas_number = desatek.desatek
            show_texts(by: true)
        }
        if synthesizer.isPaused {
            let play_img = UIImage(named: "ic_pause")
            play_button.setImage(play_img, for: .normal)
        }
        enabledDarkMode()
    }
    
    @objc func didTapOnScreen() {
        toggleNavigationBarVisibility()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.synthesizer.isSpeaking {
            self.synthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func toggleNavigationBarVisibility() {
        if let isNarBarHidden = navigationController?.isNavigationBarHidden {
            if !isNarBarHidden { // It's necessary to hide the status bar before  nav bar hidding (because of a jump of content)...
                isStatusBarHidden = !isNarBarHidden
            }
            navigationController?.setNavigationBarHidden(!isNarBarHidden, animated: true)
            if isNarBarHidden { // ... and it's necessary to show the status bar after nav bar showing (because of a jump of content).
                isStatusBarHidden = !isNarBarHidden
            }
        }
    }
    func setupView() {
        self.view.addSubview(scrollView)
        self.view.addSubview(btnViewContainer)
        self.view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: btnViewContainer)
        self.view.addConstraintsWithFormat(format: "V:|-10-[v0]-20-[v1(40)]-10-|", views: scrollView, btnViewContainer)
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(ruzenec_image)
        scrollViewContainer.addSubview(ruzenec_text_contain)
        btnViewContainer.addSubview(previous_button)
        btnViewContainer.addSubview(play_button)
        btnViewContainer.addSubview(next_button)

        scrollView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: scrollViewContainer)
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12-12).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: +10).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true

        scrollViewContainer.centerXAnchor.constraint(equalTo: ruzenec_image.centerXAnchor).isActive = true
        ruzenec_image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        ruzenec_image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //scrollViewContainer.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: ruzenec_image)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: ruzenec_text_contain)
        scrollViewContainer.addConstraintsWithFormat(format: "V:|-20-[v0]-20-[v1]", views: ruzenec_image, ruzenec_text_contain)

        btnViewContainer.addConstraintsWithFormat(format: "H:|-12-[v0(100)]", views: previous_button)
        btnViewContainer.addConstraintsWithFormat(format: "H:[v0(100)]-12-|", views: next_button)
        play_button.centerXAnchor.constraint(equalTo: btnViewContainer.centerXAnchor).isActive = true
        let play_img = UIImage(named: "ic_play")
        play_button.setImage(play_img, for: .normal)
        print("FRANTISEK LOAD FINIE")

    }
    func show_image (by direction: Bool) {
        print("show_image: \(self.image_count) and direction \(direction)")
        if direction {
            if self.image_count == -1 {
                ruzenec_image.image = nil
            }
            else {
                ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count + 1))
            }
            image_count += 1
            count += 1
        }
        else {
            ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count - 1))
            image_count -= 1
            count -= 1
        }
    }
    
    func show_texts(by direction: Bool) {
        if self.image_count == -1 {
            self.ruzenec_image.isHidden = true
        } else
        {
            self.ruzenec_image.isHidden = false

        }
        show_image(by: direction)
        if count < 7 {
            show_ruzenec_zacatek(by: direction)
        }
        else {
            show_ruzenec_text(by: direction)
        }
        self.ruzenec_text_contain.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.ruzenec_text_contain.textAlignment = .center

    }
    

    func show_ruzenec_zacatek(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        var text: NSAttributedString
        debugPrint("show_ruzenec_zacatek: count \(count)")
        switch count {
        case rn.credo:
            text = get_html_text(text: "\(rosaryStructure.VeJmenuOtce)\n\(rosaryStructure.VyznaniViry)")
            previous_button.isEnabled = false
        case rn.lord:
            text = get_html_text(text: rosaryStructure.Otcenas)
            previous_button.isEnabled = true
        case rn.salveReginaFirst:
            text = get_html_text(text: " v kterého věříme ", kindForGeneration: 1)
        case rn.salveReginaSecond:
            text = get_html_text(text: " v kterého doufáme ", kindForGeneration: 1)
        case rn.salveReginaThird:
            text = get_html_text(text: " kterého nade všechno milujeme ", kindForGeneration: 1)
        case rn.meaCulpa:
            text = get_html_text(text: rosaryStructure.SlavaOtci)
        default:
            text = get_html_text(text: "Error")
        }
        ruzenec_text_contain.attributedText = text
    }
    func show_ruzenec_text(by direction: Bool) {
        guard let rosaryStructure = rosaryStructure else { return }
        debugPrint("show_ruzenec_text: count \(count)")
        switch count {
        case rn.lordOne, rn.lordTwo, rn.lordThree, rn.lordFour, rn.lordFive, rn.lordSix, rn.lordSeven:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.Otcenas)
        case rn.rosaryOne..<(rn.meaCulpaOne-1), rn.rosaryTwo..<(rn.meaCulpaTwo-1),
            rn.rosaryThree..<(rn.meaCulpaThree-1), rn.rosaryFour..<(rn.meaCulpaFour-1),
            rn.rosaryFive..<(rn.meaCulpaFive-1), rn.rosarySix..<(rn.meaCulpaSix-1),
            rn.rosarySeven..<(rn.meaCulpaSeven-1):
            let rosary = rosaryStructure.Ruzence[self.zdravas_number - 2]
            let secret = rosary.decades[self.type_desatek]
            ruzenec_text_contain.attributedText = get_html_text(text: secret, kindForGeneration: 1)
        case rn.meaCulpaOne - 1, rn.meaCulpaTwo - 1, rn.meaCulpaThree - 1,
            rn.meaCulpaFour - 1, rn.meaCulpaFive - 1,
            rn.meaCulpaSix - 1, rn.meaCulpaSeven - 1:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.SlavaOtci)
        case rn.meaCulpaOne, rn.meaCulpaTwo, rn.meaCulpaThree, rn.meaCulpaFour, rn.meaCulpaFive, rn.meaCulpaSix:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.MojeVina)
            if direction {
                self.type_desatek += 1
            }
            else {
                self.type_desatek -= 1
            }
        case rn.meaCulpaSeven:
            ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.MojeVina)
            next_button.isEnabled = true
        case rn.salveRegina:
            if self.zdravas_number == 7 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.ZdravasKralovno)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.BolestnyRedeem)
            }
            if self.zdravas_number == 6 {
                next_button.isEnabled = true
            }
        case rn.pray, rn.painReedem:
            if self.zdravas_number == 7 {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.ZaverecnaModlitba)
            }
            else {
                ruzenec_text_contain.attributedText = get_html_text(text: rosaryStructure.BolestnyEnd)
            }
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    

    @objc func previousAction(sender: UIButton) {
        Global.vibrate()
        print("PreviousAction")
        enabledDarkMode()
        show_texts(by: false)
    }

    @objc func playAction(sender: UIButton) {
        Global.vibrate()
        print("Playaction")
        if !self.synthesizer.isSpeaking {
            let play_img = UIImage(named: "ic_stop")
            play_button.setImage(play_img, for: .normal)
            guard let rosarySpeak = rosarySpeakStructure else { return }
            guard let rosary = rosaryStructure else { return }
            let rosary_begin = "\(rosarySpeak.VyznaniViry) \(rosarySpeak.Otcenas) \(rosarySpeak.ZdravasMaria)v kterého věříme\(rosarySpeak.ZdravasMariaEnd)\(rosarySpeak.ZdravasMaria)v kterého doufáme\(rosarySpeak.ZdravasMariaEnd)\(rosarySpeak.ZdravasMaria)kterého nade všechno milujeme\(rosarySpeak.ZdravasMariaEnd) \(rosarySpeak.SlavaOtci)"
            var text_to_speak: String = ""
            for n in 0..<7 {
                print(rosary.Ruzence[desatek!.desatek - 2].decades[n])
                text_to_speak += rosarySpeak.Otcenas + String.init(repeating: "\(rosarySpeak.ZdravasMaria)\(rosary.Ruzence[desatek!.desatek - 2].decades[n])\(rosarySpeak.ZdravasMariaEnd)", count: 10) + rosarySpeak.SlavaOtci + rosarySpeak.MojeVina
            }
            text_to_speak += "\n" + rosarySpeak.ZdravasKralovno + rosarySpeak.ZaverecnaModlitba
            speakText(text: text_to_speak)
        }
        else {
            // TODO Pozastavit nebo stopnou. Dialog
            let play_img = UIImage(named: "ic_play")
            play_button.setImage(play_img, for: .normal)
            self.synthesizer.pauseSpeaking(at: .immediate)
            if !self.synthesizer.isPaused {
                let pauseDialog = UIAlertController()
                let stopPlay = UIAlertAction(title: "Zastavit přehrávání", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    self.synthesizer.stopSpeaking(at: .immediate)
                    print("playing stopped")
                })
                let pausePlay = UIAlertAction(title: "Pozastavit přehrávání", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    self.synthesizer.pauseSpeaking(at: .immediate)
                    print("playing paused")
                    let play_img = UIImage(named: "ic_pause")
                    self.play_button.setImage(play_img, for: .normal)
                })
                let cancel = UIAlertAction(title: "Zrušit", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in
                    self.synthesizer.continueSpeaking()
                    let play_img = UIImage(named: "ic_stop")
                    self.play_button.setImage(play_img, for: .normal)
                    print("continue playing")
                })
                pauseDialog.addAction(stopPlay)
                pauseDialog.addAction(pausePlay)
                pauseDialog.addAction(cancel)
                self.present(pauseDialog, animated:true,completion: nil)
            }
            else {
                let play_img = UIImage(named: "ic_stop")
                play_button.setImage(play_img, for: .normal)
                self.synthesizer.continueSpeaking()
            }
        }
        enabledDarkMode()

    }
    @objc func nextAction(sender: UIButton) {
        Global.vibrate()
        enabledDarkMode()
        show_texts(by: true)
    }
    
    @objc func speakText(text: String) {
        if self.synthesizer.isSpeaking {
            self.synthesizer.stopSpeaking(at: .immediate)
        }
        else {
            let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "cs_CZ")
            DispatchQueue.main.async {
                self.synthesizer.speak(utterance)
            }
        }
        
    }
    func enabledDarkMode() {
        self.view.backgroundColor = self.back
        self.ruzenec_text_contain.backgroundColor = self.back
        self.ruzenec_text_contain.textColor = self.text
        self.play_button.backgroundColor = self.back
        self.next_button.backgroundColor = self.back
        self.previous_button.backgroundColor = self.back
        self.next_button.setTitleColor(self.text, for: .normal)
        self.play_button.setTitleColor(self.text, for: .normal)
        self.previous_button.setTitleColor(self.text, for: .normal)
    }

    private func get_html_text(text: String, kindForGeneration: Int = 0) -> NSAttributedString {
        guard let rosaryStructure = rosaryStructure else { return NSAttributedString() }
        var main_text: String = ""
        if kindForGeneration == 0 {
            main_text = text
        }
        else if kindForGeneration == 1 {
            main_text = "\(rosaryStructure.ZdravasMaria)<red>\(text)</red>\(rosaryStructure.ZdravasMariaEnd)"
        }

        return generateContent(text: main_text, font_name: self.font_name, size: get_cgfloat(size: self.font_size), color: self.text)
    }
}
private extension FrantiskanskyRuzenecViewController {
    func setupUI() {
        ruzenec_text_contain.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
}

extension FrantiskanskyRuzenecViewController: CXCallObserverDelegate {
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        var synCallStarted: Bool = false
        var synCallFinished: Bool = false
        print(call)
        print(call.isOutgoing)
        print(call.hasEnded)
        print(call.hasConnected)
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            // detect dialing outgoing call
            synCallStarted = true
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
          //.. 3. incoming call ringing (not answered)
            synCallStarted = true
        }
        if call.hasConnected == true && call.hasEnded == false && call.isOnHold == false {
          // Incomming or OutGoing call connected
            synCallStarted = true
        }
        if call.hasEnded == true {
            // OUtgoing call has fininshed
            synCallFinished = true
        }
        if synCallStarted == true {
            if self.synthesizer.isPaused == false {
                // TODO Pozastavit nebo stopnou. Dialog
                let play_img = UIImage(named: "ic_play")
                play_button.setImage(play_img, for: .normal)
                self.synthesizer.pauseSpeaking(at: .immediate)
            }
        }
        if synCallFinished == true {
            if self.synthesizer.isPaused {
                let play_img = UIImage(named: "ic_stop")
                play_button.setImage(play_img, for: .normal)
                self.synthesizer.continueSpeaking()
            }
        }
       
    }
}
