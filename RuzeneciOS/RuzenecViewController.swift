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

    var desatky: [Int: [String]] = [0: ["kterého jsi z Ducha svatého počala",
                                        "s kterým jsi Alžbětu navštívila",
                                        "kterého jsi v Betlémě porodila",
                                        "kterého jsi v chrámě obětovala",
                                        "kterého jsi v chráme nalezla"],
                                    1: ["který se pro nás krví potil",
                                        "který byl pro nás bičován",
                                        "který byl pro nás trním korunován",
                                        "který pro nás nesl těžký kříž",
                                        "který byl pro nás ukřižován"],
                                    2: ["který z mrtvých vstal",
                                        "který na nebe vstoupil",
                                        "který Ducha svatého seslal",
                                        "který Tě, panno, do nebe vzal",
                                        "který tě v nebi korunoval"],
                                    3: ["který byl pokřtěn v Jordánu",
                                        "který zjevil v Káně svou božskou moc",
                                        "který hlásal Boží království a vyzýval k pokání",
                                        "ktery na hoře proměnění zjevil svou slávu",
                                        "který ustanovil Eucharistii"],
                                    5: ["kterého utrpení ti bylo Simeonem zvěstované",
                                        "s kterým jsi utekla do Egypta",
                                        "kterého jsi s bolestí tři dny hledala",
                                        "který se s tebou setkal na křížové cestě",
                                        "kterého jsi viděla umírat na kříži",
                                        "kterého mrtvé tělo jsi držela v náručí",
                                        "kterého jsi s bolestí do hrobu položila"],
                                    6: ["kterého jsi, Neposkvrněná Panno, s radostí z Ducha svatého počala",
                                        "s kterým jsi, Neposkvrněná Panno, s radostí Alžbětu navštívila",
                                        "kterého jsi, Neposkvrněná Panno, v Betlémě porodila",
                                        "kterého jsi, Neposkvrněná Panno, třem králům ke klanění představila",
                                        "kterého jsi, Neposkvrněná Panno, s radostí v chrámě nalezla",
                                        "kterého jsi, Neposkvrněná Panno, zmrtvýchvstalého s radostí první pozdravila",
                                        "který Tě, Neposkvrněná Panno, na nebe vzal a Královnou nebe i země korunoval"],
                                    7:  ["který jsi sv. Josefa za ženicha nejčistší Panně Marii vyvolil",
                                         "který jsi sv. Josefa jako živitele miloval",
                                         "který jsi sv. Josefa poslušný byl",
                                         "který ses se sv. Josefem modlil a pracoval",
                                         "který jsi sv. Josefa za patrona církve vyvolil"]]
    var zdravas: String = "Zdrávas, Maria, milosti plná,\nPán s tebou;\npožehnaná ty mezi ženami\na požehnaný plod života tvého, Ježíš,\n"
    var zdravas_konec: String = "\nSvatá Maria, Matko Boží,\npros za nás hříšné\nnyní i v hodinu smrti naší.\nAmen."
    var odpust_hrichy: String = "Pane Ježíši, odpusť nám naše hříchy,\nuchraň nás pekelného ohně,\npřiveď do nebe všechny duše,\nzvláště ty, které Tvého milosrdenství nejvíce potřebují."
    var konec: String = "K: Oroduj za nás, královno posvátného růžence,\nL: aby nám Kristus dal účast na svých zaslíbeních.\nK:Modleme se:\nBože, tvůj jednorozený Syn nám svým životem,\nsmrtí a zmrtvýchvstáním získal věčnou spásu.\nDej nám, prosíme, když v posvátném růženci\nblahoslavené Panny Marie o těchto tajemstvích rozjímáme,\nať také podle nich žijeme a dosáhneme toho, co slibují.\nSkrze Krista, našeho Pána.\nL: Amen."
    var zrno: Int = 0
    var desatek: Desatek?
    var typ_obrazku: String = "r"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseJSON()
        
        if let desatek = desatek {
            ruzenec_title.text = desatek.name
            zdravas_number = desatek.desatek
            print(zdravas_number)
            if zdravas_number == 5 {
               typ_obrazku = "s"
            }
            else if zdravas_number == 6 {
               typ_obrazku = "s"
            }
            show_ruzenec_zacatek(by: true)
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

    func get_colored_text(_ text: String) -> NSMutableAttributedString{
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let ns_text = NSMutableAttributedString (string: text)
        let start = text.index(text.startIndex, offsetBy: 0)
        let end = text.index(text.startIndex, offsetBy: text.count)
        let myRange = start..<end
        ns_text.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(myRange, in: text))
        let mutableZdravas = NSMutableAttributedString(string: zdravas)
        let mutableZdravasKonec = NSMutableAttributedString(string: zdravas_konec)
        mutableZdravas.append(ns_text)
        mutableZdravas.append(mutableZdravasKonec)
        return mutableZdravas
    }
    
    func zobraz_obrazek(by direction: Bool) {
        if direction {
            ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count + 1))
        }
        else {
            ruzenec_image.image = UIImage(named: String(format: "%@%d", typ_obrazku, image_count - 1))
        }
    }
    func show_ruzenec_zacatek(by direction: Bool) {
        zobraz_obrazek(by: direction)
        zvys_pocitadlo(by: direction)
        switch count {
        case 1:
            ruzenec_text_contain.text = pozdraveni + "\n" + vyznani_viry
        case 2:
            ruzenec_text_contain.text = otce_nas
        case 3:
            ruzenec_text_contain.attributedText = get_colored_text("v kterého věříme.")
            ruzenec_text_contain.textAlignment = NSTextAlignment.center
        case 4:
            ruzenec_text_contain.attributedText = get_colored_text("v kterého doufáme.")
            ruzenec_text_contain.textAlignment = NSTextAlignment.center
        case 5:
            ruzenec_text_contain.attributedText = get_colored_text("v kterého nade všechno milujeme.")
            ruzenec_text_contain.textAlignment = NSTextAlignment.center
        case 6:
            ruzenec_text_contain.text = slava
        default:
            ruzenec_text_contain.text = "Error"
        }

    }
    
    func zvys_pocitadlo (by direction: Bool) {
        if direction {
            image_count += 1
            if count != 8 {
                count += 1
            }
        }
        else {
            image_count -=  1
            if count != 8 {
                count -= 1
            }
        }
    }
    func show_ruzenec_sedmi_text(by direction: Bool) {
        zobraz_obrazek(by: direction)
        zvys_pocitadlo(by: direction)
        switch count {
        case 7:
            ruzenec_text_contain.text = otce_nas
        case 8:
            if direction {
                zrno += 1
            }
            else {
                zrno -= 1
            }
            if zrno < 8 {
                var taj = desatky[zdravas_number]
                let tajemstvi = taj![type_desatek]
                
                ruzenec_text_contain.attributedText = get_colored_text(tajemstvi)
                ruzenec_text_contain.textAlignment = NSTextAlignment.center
            }
            else if zrno == 8 {
                ruzenec_text_contain.text = slava
            }
            else {
                ruzenec_text_contain.text = odpust_hrichy
                zrno = 0
                type_desatek += 1
                if type_desatek < 7 {
                    count = 6
                }
                else {
                    count = 9
                }
            }
        case 10:
            image_count = 74
            ruzenec_text_contain.text = kralovno
            
        case 11:
            image_count = 74
            ruzenec_text_contain.text = konec
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }

    }
    func show_ruzenec_text(by direction: Bool) {
        zobraz_obrazek(by: direction)
        zvys_pocitadlo(by: direction)
        switch count {
        case 7:
            ruzenec_text_contain.text = otce_nas
        case 8:
            if direction {
                zrno += 1
            }
            else {
                zrno -= 1
            }
            if zrno < 11 {
                var taj = desatky[zdravas_number]
                let tajemstvi = taj![type_desatek]
                
                ruzenec_text_contain.attributedText = get_colored_text(tajemstvi)
                ruzenec_text_contain.textAlignment = NSTextAlignment.center
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
                    count = 6
                }
                else {
                    count = 9
                }
            }
        case 10:
            image_count = 65
            ruzenec_text_contain.text = kralovno
            
        case 11:
            image_count = 65
            ruzenec_text_contain.text = konec
            next_button.isEnabled = false
        default:
            ruzenec_text_contain.text = "Error"
        }
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Actions
    @IBAction func previous_button(_ sender: UIButton) {
        if count < 6 {
            show_ruzenec_zacatek(by: false)
        }
        else {
            if zdravas_number == 5 {
                show_ruzenec_sedmi_text(by: false)
            }
            else if zdravas_number == 6 {
                show_ruzenec_sedmi_text(by: false)
            }
            else {
                show_ruzenec_text(by: false)
            }
        }
    }

    @IBAction func next_button(_ sender: UIButton) {
        if count < 6 {
            show_ruzenec_zacatek(by: true)
        }
        else {
            if zdravas_number == 5 {
                show_ruzenec_sedmi_text(by: true)
            }
            else if zdravas_number == 6 {
                show_ruzenec_sedmi_text(by: true)
            }
            else {
                show_ruzenec_text(by: true)
            }
        }
    }
}

