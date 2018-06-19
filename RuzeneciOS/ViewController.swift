//
//  ViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 06/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var ruzenec_label: UILabel!
    @IBOutlet weak var ruzenec_text_contain: UITextView!
    @IBOutlet weak var ruzenec_image: UIImageView!
    var count: Int = 0
    var desatek: Int = 0
    var zdravas_number: Int = 0
    var name: [Int: String] = [1: "Radostny ruzenec",
                               2: "Tajemstvi svetla",
                               3: "Bolestny ruzenec",
                               4: "Slavny ruzenec"]
    var desatky: [Int: [String]] = [1: ["ktereho jsi z Ducha Svateho pocala.",
                                        "s kterym jsi Alzbetu nasvtivila",
                                        "ktereho jsi v Betleme porodila",
                                        "ktereho jsi v chrame obetovala",
                                        "ktereho jsi v chrame nalezla"],
                                    2: ["ktery byl pokrten v Jordanu.",
                                        "ktery zjevil v Kane svou bozskou moc.",
                                        "ktery hlasal Bozi kralovstvi a vyzyval k pokani.",
                                        "ktery na hore Promeneni zjevil svou slavu.",
                                        "ktery ustanovil Eucharistii."
                                        ],
                                    3: [],
                                    4: [],
                                    5: []]
    var otce_nas: String = "Otce nas, jenz jsi na nebesich, posvet se jmeno tve. Prijd kralovstvi tve. Bud vule tva jako v nebi, tak i na zemi. Chleb nas vezdejsi dej nam dnes. A odpust nam nase viny, jako i my odpoustime nasim vinikum. A neuved nas v pokuseni, ale zbav nas od zleho. Amen"
    var zdravas: String = "Zdravas, Maria, milosti plna, Pan s tebou; pozehnana ty mezi zenami a pozehnany plod zivota tveho, Jezis, "
    var zdravas_konec: String = " Svata Maria, Matko Bozi pros za nas hrisne nyni i v hodinu smrti nasi. Amen."
    var slava: String = "Slava Otci i Synu i Duchu Svatemu, jako byla na pocatku i nyni i vzdycky a na veky veku amen"
    var kralovno: String = "Zdravas Kralovno, matko milosrdenstvi, zivote sladkosti a nadeje nase bud zdrava"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        zdravas_number = 1
        desatek = 0
        ruzenec_label.text = name[zdravas_number]
        show_ruzenec_text(by: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func show_ruzenec_text(by direction: Bool) {
        let photo_str = String(format: "r%d", count)
        ruzenec_image.image = UIImage(named: photo_str)
        if count == 0 {
            ruzenec_text_contain.text = otce_nas
        }
        else if count == 11 {
            ruzenec_text_contain.text = slava
        }
        else if count == 12 {
            ruzenec_text_contain.text = kralovno
            desatek = desatek + 1
        }
        else if count >= 1 {
            var taj = desatky[zdravas_number]
            let tajemstvi = taj![desatek]
            
            let text_ruzenec = zdravas + tajemstvi + zdravas_konec
            ruzenec_text_contain.text = text_ruzenec
        }
        if direction {
            if count == 12 {
                count = 0
            }
            else {
                count = count + 1
            }
        }
        else {
            if count > 0 {
                count = count - 1
            }
        }

    }
    //MARK: Actions
    @IBAction func previous_button(_ sender: UIButton) {
        show_ruzenec_text(by: false)
    }

    @IBAction func next_button(_ sender: UIButton) {
        show_ruzenec_text(by: true)
    }
}

