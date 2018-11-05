//
//  DesatekTableViewCell.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 12/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class DesatekTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var desatekLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
