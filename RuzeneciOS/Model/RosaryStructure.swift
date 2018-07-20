//
//  RosaryStructure.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 20/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

struct RosaryStructure: Decodable {
    var lordPrayer: String
    var aveMaria: String
    var aveMariaEnd: String
    var gloriaPatri: String
    var salveRegina: String
    var rosaries: [Rosary]
}
