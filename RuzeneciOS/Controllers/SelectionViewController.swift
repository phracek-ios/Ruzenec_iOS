//
//  SelectionViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 03.06.2025.
//  Copyright © 2025 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

class SelectionViewController: UIViewController {
    
    public var key = ""
    var presentingNavigationController: UINavigationController!
    var settingsViewController: SettingsTableViewController!
    let userDefaults = UserDefaults.standard
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var backColor = KKCBackgroundLightMode
    var labelColor = KKCTextLightMode
    
    var bool_reload: Bool = true
    
    var className: String {
        return String(describing: self)
    }
    
    lazy var settingName : UILabel = {
        let b = UILabel()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.font = UIFont.boldSystemFont(ofSize: 16)
        b.numberOfLines = 0
        b.lineBreakMode = .byWordWrapping
        return b
    }()
    
    lazy var textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nastavte počet dní"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var effectView : UIVisualEffectView = {
        let b = UIVisualEffectView()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    lazy var popUpView : UIView = {
        let b = UIView()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var cancelButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        return b
    }()
    
    lazy var okButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(self.ok), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        settingName.text = "Kolik dní připomínat růženec"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setupView() {
        let darkMode = userDefaults.bool(forKey: keys.night)
        if darkMode {
            self.labelColor = KKCTextNightMode
            self.backColor = KKCBackgroundNightMode
        }
        else {
            self.labelColor = KKCTextLightMode
            self.backColor = KKCBackgroundLightMode
        }
        view.addSubview(effectView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: effectView)
        view.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: effectView)
        effectView.effect = UIBlurEffect(style: .light)
        view.sendSubview(toBack: effectView)
        view.addSubview(popUpView)
        popUpView.widthAnchor.constraint(equalToConstant: 0.5*UIScreen.main.bounds.width).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 0.6*UIScreen.main.bounds.height).isActive = true
//        let currH = 130 + 43.5 * CGFloat(currentArray!.count)
//        popUpView.heightAnchor.constraint(equalToConstant: currH).isActive = true

        popUpView.centerXAnchor.constraint(equalTo: effectView.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        popUpView.addSubview(settingName)
        popUpView.addSubview(textField)
        popUpView.addSubview(cancelButton)
        popUpView.addSubview(okButton)
        settingName.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 20).isActive = true
        settingName.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: settingName.bottomAnchor, constant: 20).isActive = true
        textField.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(self.labelColor, for: .normal)

        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(self.labelColor, for: .normal)

        cancelButton.widthAnchor.constraint(equalToConstant: 0.2*UIScreen.main.bounds.width).isActive = true
        okButton.widthAnchor.constraint(equalToConstant: 0.2*UIScreen.main.bounds.width).isActive = true

        cancelButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        okButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true

        okButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 50).isActive = true
        if userDefaults.object(forKey: keys.countRuzenec) != nil {
            textField.text = "\(userDefaults.object(forKey: keys.countRuzenec)!)"
        }

    }
    
    @objc func cancel(_ sender: UIButton) {
        print("cancel")
        self.dismiss(animated: false,completion: nil)
    }
    
    @objc func ok(_ sender: UIButton) {
        print("ok")
        if textField.text != "" {
            let result = Int(textField.text!)
            if result != nil {
                if result! < 1 || result! > 30{
                    let alert = UIAlertController(title: "Rozsah dní musí být mezi 1-30", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Zrušit", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                let userDefaults = UserDefaults.standard
                let keys = SettingsBundleHelper.SettingsBundleKeys.self
                userDefaults.set(result!, forKey: keys.countRuzenec)
                NotificationManager.removeNotifications()
                NotificationManager.updateRuzenec()
            } else {
                let alert = UIAlertController(title: "Nastavena hodnota neni cislo", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Zrušit", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.dismiss(animated: false) {
            self.presentingNavigationController.viewControllers.forEach({
                if let vc = $0 as? UIViewController {
                    self.presentingNavigationController.popViewController(animated: true)
                }
            })
        }
        
    }

}
