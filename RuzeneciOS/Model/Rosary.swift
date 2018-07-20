//
//  Rosary.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 20/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

struct Rosary: Decodable {
    var id: Int
    var name: String
    var decades: [String]
}
