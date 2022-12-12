//
//  SettingsPickerTableViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 08.12.2022.
//  Copyright © 2022 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SettingsPickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    static let cellId = "settingsPickerItem"

    var title: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        l.sizeToFit()
        l.numberOfLines = 0
        l.isUserInteractionEnabled = true
        return l
    }()
    
    var detail: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.numberOfLines = 0
        l.isUserInteractionEnabled = true
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        l.lineBreakMode = .byWordWrapping
        l.sizeToFit()
        l.contentMode = .scaleAspectFit
        return l
    }()
    
    lazy var voicePicker: UIPickerView = {
        let i = UIPickerView()
        i.frame = CGRect(x:0, y:0, width: 100, height: 20)
        return i
    }()
    
    var delegate: SettingsDelegate?
    
    var settingsItem: SettingsItem?
    
    var voiceData: [String] = [String]()
    let userDefaults = UserDefaults.standard
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var backColor = KKCBackgroundLightMode
    var labelColor = KKCTextLightMode
    let synthesizer = AVSpeechSynthesizer()
    
    func configureCell(settingsItem: SettingsItem, delegate: SettingsDelegate, cellWidth: CGFloat) {
        self.settingsItem = settingsItem
        self.voicePicker.delegate = self
        self.voicePicker.dataSource = self
        addSubview(title)
        addSubview(detail)
        self.accessoryView = voicePicker
        print(AVSpeechSynthesisVoice(language: "cs_CZ"))
        print(AVSpeechSynthesisVoice.speechVoices())
//        if UserDefaults.standard.object(forKey: settingsItem.prefsString) != nil {
//            voice = CGFloat(UserDefaults.standard.integer(forKey: settingsItem.prefsString))
//        }
//        title.text = settingsItem.title
//        detail.attributedText = generateContent(text: settingsItem.detail, size: fontSize, color: KKCMainColor)
        let darkMode = userDefaults.bool(forKey: keys.night)
        if darkMode {
            self.labelColor = KKCTextNightMode
            self.backColor = KKCBackgroundNightMode
        }
        else {
            self.labelColor = KKCTextLightMode
            self.backColor = KKCBackgroundLightMode
        }
        title.textColor = self.labelColor
        detail.textColor = self.labelColor
        self.backgroundColor = self.backColor
        title.backgroundColor = self.backColor
        title.textColor = self.labelColor
        detail.backgroundColor = self.backColor
        detail.textColor = self.labelColor
        
        let titleWidth = cellWidth - voicePicker.frame.width - 12 - 15 - 12
        let detailWidth = cellWidth - voicePicker.frame.width - 12 - 20
        addConstraintsWithFormat(format: "H:|-12-[v0(\(titleWidth))]", views: title)
        addConstraintsWithFormat(format: "H:|-12-[v0(\(detailWidth))]", views: detail)
        addConstraintsWithFormat(format: "V:|-20-[v0]-10-[v1]", views: title, detail)

//        detail.widthAnchor.constraint(equalTo: title.widthAnchor ).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.voiceData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.voiceData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        let voice = voiceData[pickerView.selectedRow(inComponent: 0)]
        userDefaults.set(voice, forKey: keys.voice)

    }}
