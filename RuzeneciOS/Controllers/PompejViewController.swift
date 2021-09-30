//
//  PompejViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 27.09.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import Foundation
import BonMot
import AVFoundation

class PompejViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    
    lazy var novenaLabelCounter: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.layer.borderWidth = 2
        l.layer.cornerRadius = 5
        return l
    }()

    lazy var pompejskaNovenaProsebna: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("I. 27dní prosebných", for: .normal)
        btn.addTarget(self, action: #selector(prosebnaAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        return btn
    }()

    lazy var pompejskaNovenaDekovna: UIButton = {
        let btn = UIButton()
        btn.setTitle("II. 27dní děkovných", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dekovnaAction), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
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
    
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    var darkMode: Bool = true
    var font_name: String = "Helvetica"
    var font_size: String = "16"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        if darkMode {
            navigationController?.navigationBar.tintColor = KKCTextNightMode
        }
        else {
            navigationController?.navigationBar.tintColor = KKCTextLightMode
        }
        let novenaCounter = userDefaults.integer(forKey: keys.pompejCounter)
        novenaLabelCounter.text = "\(novenaCounter). den novény"
        novenaLabelCounter.textAlignment = .center
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
        enabledDarkMode()
    }
    
    func enabledDarkMode() {
        self.view.backgroundColor = self.back
        self.novenaLabelCounter.backgroundColor = self.back
        self.novenaLabelCounter.textColor = self.text
        self.pompejskaNovenaProsebna.backgroundColor = self.back
        self.pompejskaNovenaDekovna.backgroundColor = self.back
        self.pompejskaNovenaProsebna.backgroundColor = self.back
        self.pompejskaNovenaDekovna.setTitleColor(self.text, for: .normal)
        self.pompejskaNovenaProsebna.setTitleColor(self.text, for: .normal)
        pompejskaNovenaDekovna.layer.borderColor = self.text.cgColor
        pompejskaNovenaProsebna.layer.borderColor = self.text.cgColor
        novenaLabelCounter.layer.borderColor = self.text.cgColor
    }
    
    func setupView() {
        self.view.addSubview(scrollView)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: scrollView)
        self.view.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: scrollView)
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.addSubview(scrollViewContainer)

        scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollViewContainer)
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: +10).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        scrollViewContainer.addSubview(novenaLabelCounter)
        scrollViewContainer.addSubview(pompejskaNovenaProsebna)
        scrollViewContainer.addSubview(pompejskaNovenaDekovna)

        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: novenaLabelCounter)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: pompejskaNovenaProsebna)
        scrollViewContainer.addConstraintsWithFormat(format: "H:|-10-[v0]-30-|", views: pompejskaNovenaDekovna)
        scrollViewContainer.addConstraintsWithFormat(format: "V:|-20-[v0(70)]-40-[v1]-20-[v2]-20-|", views: novenaLabelCounter, pompejskaNovenaProsebna, pompejskaNovenaDekovna)
        
    }
        
    @objc func prosebnaAction(sender: UIButton) {
        Global.vibrate()
        print("ProsebnaAction")
        let pompejPray = PompejPrayViewController()
        navigationController?.pushViewController(pompejPray, animated: true)
    }
    
    @objc func dekovnaAction(sender: UIButton) {
        Global.vibrate()
        print("DekovnaAction")
        let pompejPray = PompejPrayViewController()
        pompejPray.dekovna = true
        navigationController?.pushViewController(pompejPray, animated: true)
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
    
    @objc func didTapOnScreen() {
        toggleNavigationBarVisibility()
    }
    
}

private extension PompejViewController {
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
}
