//
//  Constants.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 05/11/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

enum RosaryConstants: Int {
    case dnes = 0, radostny, bolestny, svetla, slavny, korunka, sedmibolestne, sedmiradostne, sv_Josef
}

struct RosaryNumbers {
    let counter: Int = 13
    let lordFirst: Int = 7
    let lordSecond: Int
    let lordThird: Int
    let lordFourth: Int
    let lordFifth: Int
    let rosaryFirst: Int
    let rosarySecond: Int
    let rosaryThird: Int
    let rosaryFourth: Int
    let rosaryFifth: Int
    let pray: Int
    let meaCulpaFirst: Int
    let meaCulpaSecond: Int
    let meaCulpaThird: Int
    let meaCulpaFourth: Int
    let meaCulpaFifth: Int
    let salveRegina: Int
    init() {
        self.lordSecond = lordFirst + counter
        self.lordThird = lordSecond + counter
        self.lordFourth = lordThird + counter
        self.lordFifth = lordFourth + counter
        self.rosaryFirst = lordFirst + 1
        self.rosarySecond = lordSecond + 1
        self.rosaryThird = lordThird + 1
        self.rosaryFourth = lordFourth + 1
        self.rosaryFifth = lordFifth + 1
        self.meaCulpaFirst = lordSecond - 1
        self.meaCulpaSecond = lordThird - 1
        self.meaCulpaThird = lordFourth - 1
        self.meaCulpaFourth = lordFifth - 1
        self.meaCulpaFifth = rosaryFifth + 11
        self.salveRegina = meaCulpaFifth + 1
        self.pray = salveRegina + 1
    }
}

struct RosarySevenNumbers {
    let counter: Int = 10
    let lordOne: Int = 7
    let lordTwo: Int
    let lordThree: Int
    let lordFour: Int
    let lordFive: Int
    let lordSix: Int
    let lordSeven: Int
    let rosaryOne: Int
    let rosaryTwo: Int
    let rosaryThree: Int
    let rosaryFour: Int
    let rosaryFive: Int
    let rosarySix: Int
    let rosarySeven: Int
    let pray: Int
    let meaCulpaOne: Int
    let meaCulpaTwo: Int
    let meaCulpaThree: Int
    let meaCulpaFour: Int
    let meaCulpaFive: Int
    let meaCulpaSix: Int
    let meaCulpaSeven: Int
    let salveRegina: Int
    init() {
        self.lordTwo = lordOne + counter
        self.lordThree = lordTwo + counter
        self.lordFour = lordThree + counter
        self.lordFive = lordFour + counter
        self.lordSix = lordFive + counter
        self.lordSeven = lordSix + counter
        self.rosaryOne = lordOne + 1
        self.rosaryTwo = lordTwo + 1
        self.rosaryThree = lordThree + 1
        self.rosaryFour = lordFour + 1
        self.rosaryFive = lordFive + 1
        self.rosarySix = lordSix + 1
        self.rosarySeven = lordSeven + 1
        self.meaCulpaOne = lordTwo - 1
        self.meaCulpaTwo = lordThree - 1
        self.meaCulpaThree = lordFour - 1
        self.meaCulpaFour = lordFive - 1
        self.meaCulpaFive = lordSix - 1
        self.meaCulpaSix = lordSeven - 1
        self.meaCulpaSeven = rosarySeven + 11
        self.salveRegina = meaCulpaSeven + 1
        self.pray = salveRegina + 1
    }
}

struct Crown {
    let counter: Int = 10
    let lord: Int = 1
    let salve: Int
    let credo: Int
    let saintOne: Int
    let saintTwo: Int
    let saintThree: Int
    let crownOne: Int
    let crownTwo: Int
    let crownThree: Int
    let crownFour: Int
    let crownFive: Int
    let smallCrownOne: Int
    let smallCrownTwo: Int
    let smallCrownThree: Int
    let smallCrownFour: Int
    let smallCrownFive: Int
    init () {
        self.salve = lord + 1
        self.credo = salve + 1
        self.crownOne = credo + 1
        self.smallCrownOne = crownOne + 1
        self.crownTwo = smallCrownOne + counter
        self.smallCrownTwo = crownTwo + 1
        self.crownThree = smallCrownTwo + counter
        self.smallCrownThree = crownThree + 1
        self.crownFour = smallCrownThree + counter
        self.smallCrownFour = crownFour + 1
        self.crownFive = smallCrownFour + counter
        self.smallCrownFive = crownFive + 1
        self.saintOne = smallCrownFive + counter
        self.saintTwo = saintOne + 1
        self.saintThree = saintTwo + 1
    }
}
