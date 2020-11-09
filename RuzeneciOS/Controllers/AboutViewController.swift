//
//  AboutViewController.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 11/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class AboutViewController: UIViewController, UITextViewDelegate {
    
    // MARK properties
    lazy var aboutWebView: WKWebView = {
        let wk = WKWebView()
        wk.translatesAutoresizingMaskIntoConstraints = false
        return wk
    }()

    
    var darkMode: Bool = false
    var text_dark: String = ""
    var text_light: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "O aplikaci"
        setupView()
        let htmlString = "Růženec<br>Autor mobilní aplikace: Petr Hráček<br><br>Případné chyby, návrhy, připomínky, nápady či postřehy prosím zašlete na adresu:<br> <a href=\"phracek@gmail.com\">phracek@gmail.com</a>"
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        self.aboutWebView.isOpaque = false
        self.text_dark = "<div style=\"color:#ffffff\"><font size=20>" + htmlString + "</font></div></body></html>"
        self.text_light = "<div style=\"color:#000000\"><font size=20>" + htmlString + "</font></div></body></html>"
        let html = "<html><body style='margin: 40px'>"
        if self.darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
            aboutWebView.backgroundColor = KKCBackgroundNightMode
            aboutWebView.tintColor = KKCTextNightMode
            aboutWebView.loadHTMLString(html + self.text_dark, baseURL: nil)
        }
        else {
            self.view.backgroundColor = KKCBackgroundLightMode
            aboutWebView.backgroundColor = KKCBackgroundLightMode
            aboutWebView.tintColor = KKCTextLightMode
            aboutWebView.loadHTMLString(html + self.text_light, baseURL: nil)
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
    
    func setupView() {
        self.view.addSubview(aboutWebView)
        self.view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: aboutWebView)
        self.view.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: aboutWebView)
        aboutWebView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
        self.aboutWebView.backgroundColor = KKCBackgroundNightMode
        aboutWebView.loadHTMLString("<html><body>" + self.text_dark, baseURL: nil)
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
        self.aboutWebView.backgroundColor = KKCBackgroundLightMode
        aboutWebView.loadHTMLString("<html><body>" + self.text_light, baseURL: nil)
    }
}
