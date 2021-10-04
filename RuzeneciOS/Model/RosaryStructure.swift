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
    var aveMariaFull: String
    var gloriaPatri: String
    var salveRegina: String
    var inNominePatri: String
    var credo: String
    var pray: String
    var prayJosef: String
    var meaCulpa: String
    var korunka_main: String
    var korunka_rosary: String
    var korunka_end: String
    var meaCulpaOriginal: String
    var painEnd: String
    var painRedeem: String
    var pompej_umysl: String
    var pompej_prosebna: String
    var pompej_dekovna: String
    var pompej_pod_ochranu: String
    var pompej_oroduj: String
    var rosaries: [Rosary]
}

struct RosarySpeakStructure: Decodable {
    var lordPrayer: String
    var aveMaria: String
    var aveMariaEnd: String
    var aveMariaFull: String
    var gloriaPatri: String
    var salveRegina: String
    var inNominePatri: String
    var credo: String
    var pray: String
    var prayJosef: String
    var meaCulpa: String
    var korunka_main: String
    var korunka_rosary: String
    var korunka_end: String
    var meaCulpaOriginal: String
    var painEnd: String
    var painRedeem: String
    var pompej_umysl: String
    var pompej_prosebna: String
    var pompej_dekovna: String
    var pompej_pod_ochranu: String
    var pompej_oroduj: String
}
