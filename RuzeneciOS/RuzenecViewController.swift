//
//  RuzenecViewController.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 06/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class RuzenecViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var ruzenec_text_contain: UITextView!
    @IBOutlet weak var ruzenec_image: UIImageView!
    @IBOutlet weak var ruzenec_title: UILabel!
    @IBOutlet weak var next_button: UIButton!
    var count: Int = 0
    var image_count: Int = 0
    var type_desatek: Int = 0
    var zdravas_number: Int = 0
    var otce_nas: String = "Otče náš, jenž jsi na nebesích,\nposvěť se jméno tvé.\nPřijď království tvé.\nBuď vůle tvá jako v nebi, tak i na zemi.\nChléb náš vezdejší dej nám dnes.\nA odpusť nám naše viny,\njako i my odpouštíme našim viníkům.\nA neuveď nás v pokušení,\nale zbav nás od zlého.\nAmen."
    var slava: String = "Sláva Otci i Synu i Duchu svatému, jako byla na počátku, i nyní, i vždycky a na věky věků. Amen."
    var kralovno: String = "Zdrávas Královno, matko milosrdenství, živote, sladkosti a naděje naše, buď zdráva! K tobě voláme, vyhnaní synové Evy, k tobě vzdycháme, lkajíce a plačíce v tomto slzavém údolí. A proto, orodovnice naše, obrať k nám své milosrdné oči a Ježíše, požehnaný plod života svého, nám po tomto putování ukaž, ó milostivá, ó přívětivá, ó přesladká, Panno Maria!"
    var pozdraveni: String = "Ve jménu Otce i Syna i Ducha svatého Amen.\n\n"
    var vyznani_viry: String = "Věřím v Boha, Otce všemohoucího, Stvořitele nebe i země. I v Ježíše Krista, Syna jeho Jediného, Pána našeho;\njenž se počal z Ducha svatého, narodil se z Marie Panny, trpěl pod Ponciem Pilátem, ukřižován umřel i pohřben jest;\nsestoupil do pekel, třetího dne vstal z mrtvých; vstoupil na nebesa, sedí po pravici Boha, Otce všemohoucího; odtud přijde soudit živé i mrtvé.\nVěřím v Ducha Svatého, svatou církev obecnou, společenství svatých, odpuštění hříchů, vzkříšení těla a život věčný.\nAmen."

    var desatky: [Int: [String]] = [0:
        ["kterého jsi z Ducha svatého počala",
         "s kterým jsi Alžbětu navštívila",
         "kterého jsi v Betlémě porodila",
         "kterého jsi v chrámě obětovala",
         "kterého jsi v chráme nalezla"],
                                    1:
    ["který se pro nás krví potil",
    "který byl pro nás bičován",
    "který byl pro nás trním korunován",
    "který pro nás nesl těžký kříž",
    "který byl pro nás ukřižován"],
                                    2:
    ["který z mrtvých vstal",
    "který na nebe vstoupil",
    "který Ducha svatého seslal",
    "který Tě, panno, do nebe vzal",
    "který tě v nebi korunoval"],
                                    3:
    ["který byl pokřtěn v Jordánu",
    "který zjevil v Káně svou božskou moc",
    "který hlásal Boží království a vyzýval k pokání",
    "ktery na hoře proměnění zjevil svou slávu",
    "který ustanovil Eucharistii"]]
    var zdravas: String = "Zdrávas, Maria, milosti plná,\nPán s tebou;\npožehnaná ty mezi ženami\na požehnaný plod života tvého, Ježíš,\n"
    var zdravas_konec: String = "\nSvatá Maria, Matko Boží,\npros za nás hříšné\nnyní i v hodinu smrti naší.\nAmen."
    var odpust_hrichy: String = "Pane Ježíši, odpusť nám naše hříchy,\nuchraň nás pekelného ohně,\npřiveď do nebe všechny duše,\nzvláště ty, které Tvého milosrdenství nejvíce potřebují."
    var konec: String = "K: Oroduj za nás, královno posvátného růžence,\nL: aby nám Kristus dal účast na svých zaslíbeních.\nK:Modleme se:\nBože, tvůj jednorozený Syn nám svým životem,\nsmrtí a zmrtvýchvstáním získal věčnou spásu.\nDej nám, prosíme, když v posvátném růženci\nblahoslavené Panny Marie o těchto tajemstvích rozjímáme,\nať také podle nich žijeme a dosáhneme toho, co slibují.\nSkrze Krista, našeho Pána.\nL: Amen."
    var zrno: Int = 0
    var desatek: Desatek?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //parseJSON()
        
        if let desatek = desatek {
            ruzenec_title.text = desatek.name
            zdravas_number = desatek.desatek
            show_ruzenec_text(by: true)
        }
    }

    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "ruzenec", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(jsonResult)
            
            if let str = (jsonResult as! NSDictionary).value(forKey: "otce_nas") {
                otce_nas = str as? String ?? ""
            }
        } else {
            print("File not found")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func show_ruzenec_text(by direction: Bool) {
        let attrs = [NSAttributedStringKey.foregroundColor : UIColor.red]
        switch count {
        case 0:
            ruzenec_text_contain.text = pozdraveni + "\n" + vyznani_viry
        case 1:
            ruzenec_text_contain.text = otce_nas
        case 2:
            var text: String = "v kterého věříme."
            //let myMutableString = NSMutableAttributedString(string: text, attributes: attrs)

            ruzenec_text_contain.text = zdravas + "v kterého věříme." + zdravas_konec
        case 3:
            ruzenec_text_contain.text = zdravas + "v kterého doufáme." + zdravas_konec
        case 4:
            ruzenec_text_contain.text = zdravas + "v kterého nade všechno milujeme." + zdravas_konec
        case 5:
            ruzenec_text_contain.text = slava
        case 6:
            ruzenec_text_contain.text = otce_nas
        case 7:
            zrno += 1
            if zrno < 11 {
                var taj = desatky[zdravas_number]
                let tajemstvi = taj![type_desatek]
                
                let text_ruzenec = zdravas + tajemstvi + zdravas_konec
                ruzenec_text_contain.text = text_ruzenec
            }
            else if zrno == 11 {
                ruzenec_text_contain.text = slava
            }
            else {
                ruzenec_text_contain.text = odpust_hrichy
                zrno = 0
                image_count -= 1
                type_desatek += 1
                if type_desatek < 5 {
                    count = 5
                }
                else {
                    count = 8
                }
            }
        case 9:
            image_count = 65
            ruzenec_text_contain.text = kralovno
            
        case 10:
            image_count = 65
            ruzenec_text_contain.text = konec
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
        let photo_str = String(format: "r%d", image_count + 1)
        ruzenec_image.image = UIImage(named: photo_str)
        if direction {
            image_count += 1
            if count != 7 {
                count += 1
            }
        }
        else {
            image_count -=  1
        }
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Actions
    @IBAction func previous_button(_ sender: UIButton) {
        show_ruzenec_text(by: false)
    }

    @IBAction func next_button(_ sender: UIButton) {
        show_ruzenec_text(by: true)
    }
}

