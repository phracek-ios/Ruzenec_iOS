//
//  Desatek.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 15/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class Desatek {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var desatek: Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, desatek: Int){
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The type must not be negative
        guard (desatek >= 0) && (desatek <= 6) else {
            return nil
        }
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.desatek = desatek
        
    }
}
