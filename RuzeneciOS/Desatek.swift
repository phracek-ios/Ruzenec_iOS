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
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?){
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties
        self.name = name
        self.photo = photo
        
    }
}
