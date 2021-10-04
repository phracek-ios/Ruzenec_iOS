//
//  PompejPrayViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 27.09.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import Foundation
import BonMot
import AVFoundation

class PompejPrayViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    
    lazy var novenaTitleLable: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

   
    lazy var pompejImage: UIImageView = {
        let ri = UIImageView()
        ri.image = UIImage(named: "pompej_full")
        ri.translatesAutoresizingMaskIntoConstraints = false
        ri.sizeToFit()
        return ri
    }()
    
    lazy var pompejStructureBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Popis novény", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(popisAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        return btn
    }()
    
    lazy var finishDay: UIButton = {
        let btn = UIButton()
        btn.setTitle("Ukončit den novény", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        return btn
    }()
    
    lazy var play_button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var fullText: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
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
    
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    var darkMode: Bool = true
    var font_name: String = "Helvetica"
    var font_size: String = "16"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var dekovna: Bool = false
    var show_full: Bool = true
    let synthesizer = AVSpeechSynthesizer()
    fileprivate var rosaryStructure: RosaryStructure?
    fileprivate var rosarySpeakStructure: RosarySpeakStructure?
    
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.scrollView.delegate = self
        self.view.isUserInteractionEnabled = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rosaryStructure = RosaryDataService.shared.rosaryStructure
        rosarySpeakStructure = RosaryDataService.shared.rosarySpeakStructure
        let userDefaults = UserDefaults.standard
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
        setupUI()

        enabledDarkMode()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(self.synthesizer.isSpeaking)
        if self.synthesizer.isSpeaking {
            self.synthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    func enabledDarkMode() {
        self.view.backgroundColor = self.back
        self.novenaTitleLable.backgroundColor = self.back
        self.novenaTitleLable.textColor = self.text
        self.pompejStructureBtn.setTitleColor(self.text, for: .normal)
        self.pompejStructureBtn.layer.borderColor = self.text.cgColor
        self.finishDay.layer.borderColor = self.text.cgColor
        self.finishDay.setTitleColor(self.text, for: .normal)
        self.fullText.backgroundColor = self.back
        self.fullText.textColor = self.text

    }
    func setupUI() {
        var title = "Prosebná Pompejská novéna"
        if dekovna {
            title = "Děkovná Pompejská novéna"
        }
        novenaTitleLable.text = title
        novenaTitleLable.textAlignment = .center
        let play_img = UIImage(named: "ic_play")
        play_button.setImage(play_img, for: .normal)
        guard let rosary = rosaryStructure else { return }
        var full_text = "\(rosary.pompej_umysl)<br>\(rosary.credo)<br><br>\(rosary.lordPrayer)<br><br>\(rosary.aveMaria)v kterého věříme\(rosary.aveMariaEnd)<br><br>\(rosary.aveMaria)v kterého doufáme\(rosary.aveMariaEnd)<br><br>\(rosary.aveMaria)kterého nade všechno milujeme\(rosary.aveMariaEnd)<br><br>\(rosary.gloriaPatri)<br><br>"
        full_text += "<br>" + "<red>Radostný růženec</red><br><br>"
        if dekovna {
            full_text += rosary.pompej_dekovna
        } else {
            full_text += rosary.pompej_prosebna
        }
        full_text += "<br>" + "<red>Bolestný růženec</red><br><br>"
        if dekovna {
            full_text += rosary.pompej_dekovna
        } else {
            full_text += rosary.pompej_prosebna
        }
        full_text += "<br>" + "<red>Slavný růženec</red><br><br>"
        if dekovna {
            full_text += rosary.pompej_dekovna
        } else {
            full_text += rosary.pompej_prosebna
        }
        full_text += "<br>" + rosary.pompej_pod_ochranu + "<br><br>" + rosary.pompej_oroduj + "<br><br>" + rosary.pompej_oroduj + "<br><br>"+rosary.pompej_oroduj
        fullText.attributedText = generateContent(text: full_text)
        self.fullText.isHidden = show_full
    }
    func setupView() {

        print("Steup")
        self.view.addSubview(scrollView)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: scrollView)
        self.view.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: scrollView)
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(scrollViewContainer)

        scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollViewContainer)
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: +10).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        scrollViewContainer.addSubview(novenaTitleLable)
        scrollViewContainer.addSubview(pompejImage)
        scrollViewContainer.addSubview(play_button)
        scrollViewContainer.addSubview(finishDay)
        scrollViewContainer.addSubview(pompejStructureBtn)
        scrollViewContainer.addSubview(fullText)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: novenaTitleLable)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-30-[v0(300)]-30-|", views: pompejImage)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: play_button)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: finishDay)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: pompejStructureBtn)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: fullText)
        scrollViewContainer.addConstraintsWithFormat(format: "V:|-20-[v0]-40-[v1(300)]-20-[v2]-20-[v3]-20-[v4]-20-[v5]-20-|", views: novenaTitleLable, pompejImage, play_button, finishDay, pompejStructureBtn, fullText)
        
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
    
    @objc func popisAction(sender: UIButton) {
        Global.vibrate()
        self.show_full = !show_full
        self.fullText.isHidden = show_full

    }
    
    @objc func finishAction(sender: UIButton) {
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        var count = userDefaults.integer(forKey: keys.pompejCounter)
        count += 1
        if count == 54 {
            count = 0
        }
        userDefaults.setValue(count, forKey: keys.pompejCounter)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func playAction(sender: UIButton) {
        Global.vibrate()
        print("Playaction \(self.synthesizer.isSpeaking)")
        if !self.synthesizer.isSpeaking {
            let play_img = UIImage(named: "ic_stop")
            play_button.setImage(play_img, for: .normal)
            guard let rosarySpeak = rosarySpeakStructure else { return }
            guard let rosary = rosaryStructure else { return }
            var text_to_speak = "\(rosarySpeak.pompej_umysl)     \(rosarySpeak.credo)   \(rosarySpeak.lordPrayer) \(rosarySpeak.aveMaria)v kterého věříme\(rosarySpeak.aveMariaEnd)\(rosarySpeak.aveMaria)v kterého doufáme\(rosarySpeak.aveMariaEnd)\(rosarySpeak.aveMaria)kterého nade všechno milujeme\(rosarySpeak.aveMariaEnd) \(rosarySpeak.gloriaPatri) "
            print(text_to_speak)
            for m in [1, 2, 4] {
                print(m)
                for n in 0..<5 {
                    text_to_speak += rosarySpeak.lordPrayer + String.init(repeating: "\(rosarySpeak.aveMaria)\(rosary.rosaries[m - 1].decades[n])\(rosarySpeak.aveMariaEnd)", count: 10) + rosarySpeak.gloriaPatri + rosarySpeak.meaCulpa
                }
                text_to_speak += rosarySpeak.salveRegina + rosarySpeak.pray
                if dekovna {
                    text_to_speak += rosarySpeak.pompej_dekovna
                } else {
                    text_to_speak += rosarySpeak.pompej_prosebna
                }
            }
            text_to_speak += rosarySpeak.pompej_pod_ochranu + rosarySpeak.pompej_oroduj
            print(text_to_speak)
            speakText(text: text_to_speak)
            print("playing finished")
            
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
}
