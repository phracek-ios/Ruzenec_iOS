//
//  SettingsTextTableViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 03.06.2025.
//  Copyright © 2025 Petr Hracek. All rights reserved.
//

import Foundation

import UIKit

class SettingsTextTableViewCell: UITableViewCell {

    static let cellId = "settingsTextItem"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var backColor = KKCBackgroundLightMode
    var labelColor = KKCTextLightMode
    
    var title: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        return l
    }()
    
    var detail: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    var value : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        return l
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let userDefaults = UserDefaults.standard
    
    func configureCell(settingsItem: SettingsItem, cellWidth: CGFloat) {
        print("SettingsTextTableViewCell configureCell: and \(settingsItem.title) \(settingsItem.detail)")
        let darkMode = userDefaults.bool(forKey: keys.night)
        if darkMode {
            self.labelColor = KKCTextNightMode
            self.backColor = KKCBackgroundNightMode
        }
        else {
            self.labelColor = KKCTextLightMode
            self.backColor = KKCBackgroundLightMode
        }
        //self.delegate = delegate
        title.text = settingsItem.title
        detail.text = settingsItem.detail
        contentView.addSubview(stackView)
        contentView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        stackView.addSubview(title)
        stackView.addSubview(value)
        stackView.addSubview(detail)
        
        title.text = settingsItem.title
        //detail.attributedText = generateContent(text: settingsItem.detail, color: UIColor.DonatorColors.black100Color())

        title.textColor = self.labelColor
        
        value.textColor = self.labelColor
        self.backgroundColor = self.backColor
        

        var count: Int = 7
        if userDefaults.object(forKey: keys.countRuzenec) != nil {
            count = userDefaults.integer(forKey: keys.countRuzenec)
        }
        value.text = "\(count)"
        stackView.addConstraintsWithFormat(format: "H:|-20-[v0]", views: title)
        stackView.addConstraintsWithFormat(format: "H:[v0]-20-|", views: value)
        stackView.addConstraintsWithFormat(format: "H:|-20-[v0]", views: detail)
        stackView.addConstraintsWithFormat(format: "V:|-20-[v0]-20-[v1]", views: title, detail)
        stackView.addConstraintsWithFormat(format: "V:|-20-[v0]", views: value)

    }

}
