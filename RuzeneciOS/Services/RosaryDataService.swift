//
//  RosaryDataService.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 20/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

class RosaryDataService {
    
    // MARK: - Shared
    static var shared = RosaryDataService()
    
    // MARK: - Properties
    var rosaryStructure: RosaryStructure?
    
    // MARK: -
    func loadData() {
        parseJSON()
    }
    
    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "ruzenec", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                rosaryStructure = try JSONDecoder().decode(RosaryStructure.self, from: data)
                //print(rosaryStructure.debugDescription)
            } catch {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
}
