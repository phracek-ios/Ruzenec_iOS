//
//  RosaryStructure.swift
//  RuzeneciOS
//
//  Created by Jiri Ostatnicky on 20/07/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

struct RosaryStructure: Decodable {
    var Otcenas: String
    var ZdravasMaria: String
    var ZdravasMariaEnd: String
    var ZdravasMariaFull: String
    var SlavaOtci: String
    var ZdravasKralovno: String
    var VeJmenuOtce: String
    var VyznaniViry: String
    var ZaverecnaModlitba: String
    var ZaverecnaModlitbaJosef: String
    var MojeVina: String
    var KorunkaHlavni: String
    var KorunkaRuzenec: String
    var KorunkaKonec: String
    var MojeVinaOriginal: String
    var BolestnyEnd: String
    var BolestnyRedeem: String
    var PompejUmysl: String
    var PompejProsebna: String
    var PompejDekovna: String
    var PompejPodOchranu: String
    var PompejOroduj: String
    var otPioPoZrnkuZaver: String
    var otPioUvod: String
    var otPioPoDesatku: String
    var otPioZaver: String
    var otPioPrisliby: String
    var Ruzence: [Rosary]
}

struct RosarySpeakStructure: Decodable {
    var Otcenas: String
    var ZdravasMaria: String
    var ZdravasMariaEnd: String
    var ZdravasMariaFull: String
    var SlavaOtci: String
    var ZdravasKralovno: String
    var VeJmenuOtce: String
    var VyznaniViry: String
    var ZaverecnaModlitba: String
    var ZaverecnaModlitbaJosef: String
    var MojeVina: String
    var KorunkaHlavni: String
    var KorunkaRuzenec: String
    var KorunkaKonec: String
    var MojeVinaOriginal: String
    var BolestnyEnd: String
    var BolestnyRedeem: String
    var PompejUmysl: String
    var PompejProsebna: String
    var PompejDekovna: String
    var PompejPodOchranu: String
    var PompejOroduj: String
    var otPioPoZrnkuZaver: String
    var otPioUvod: String
    var otPioPoDesatku: String
    var otPioZaver: String
    var otPioPrisliby: String
}
