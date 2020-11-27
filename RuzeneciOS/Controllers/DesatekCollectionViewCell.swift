//
//  DesatekCollectionViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 12/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class DesatekCollectionViewCell: UICollectionViewCell {

    static let cellId = "DesatekCollectionViewCell"
    
    //MARK: Properties
    var image_name: String?
    var name: String?
    
    lazy var photoImageView: UIImageView = {
        let piv = UIImageView()
        piv.translatesAutoresizingMaskIntoConstraints = false
        piv.sizeToFit()
        return piv
    }()
    
    lazy var desatekLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    func configureCell(name: String, image_name: String) {
        let userDefaults = UserDefaults.standard
        let imgHeight : CGFloat = 75
        let img = UIImage(named: image_name)


        photoImageView.image = img
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true

        let darkMode = userDefaults.bool(forKey: keys.night)
        if darkMode {
            desatekLabel.textColor = KKCTextNightMode
            desatekLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            desatekLabel.textColor = KKCTextLightMode
            desatekLabel.backgroundColor = KKCBackgroundLightMode
        }
        
        self.addSubview(photoImageView)
        self.addSubview(desatekLabel)
        desatekLabel.text = name
        desatekLabel.textAlignment = .left
        addConstraintsWithFormat(format: "V:|-5-[v0(\(imgHeight))]-5-|", views: photoImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: desatekLabel)
        addConstraintsWithFormat(format: "H:|-5-[v0]-20-[v1]-5-|", views: photoImageView, desatekLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
