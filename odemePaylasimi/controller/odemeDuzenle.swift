//
//  OdemeDuzenleVC.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import UIKit
import RealmSwift

class OdemeDuzenle: UIViewController {

    
    var secilenOdeme : Odeme?
    var secilenAktivite: Aktivite?
    let realm = try! Realm()
    
   
    @IBOutlet weak var txtOdemeKisiAdi: UITextField!
    
    @IBOutlet weak var txtaAciklama: UITextField!
    
    @IBOutlet weak var lblAktiviteAdi: UILabel!
    @IBOutlet weak var txtUcret: UITextField!
    
    @IBOutlet weak var lblToplamOdeme: UILabel!
    @IBAction func btnGuncelleClicked(_ sender: Any) {
        
        if let secilenOdeme=secilenOdeme{
            do{
                
                try realm.write{
                    secilenOdeme.odeyeninAdi = txtOdemeKisiAdi.text!
                    secilenOdeme.aciklama = txtaAciklama.text!
                    secilenOdeme.miktar = Int((txtUcret.text)!)!
                }
                
            }catch{
                print("ödeme hatası \(error.localizedDescription)")
                
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gorunumuAyarla()
    }
    
    
    func gorunumuAyarla(){
        txtOdemeKisiAdi.text = secilenOdeme?.odeyeninAdi
        txtaAciklama.text = secilenOdeme?.aciklama
        txtUcret.text = "\(secilenOdeme!.miktar)"
        
        lblAktiviteAdi.text = "Aktivite Adı:\(secilenAktivite!.Adi)"
        let toplamOdeme = secilenAktivite?.odemeler.filter("odeyeninAdi == %@", secilenOdeme!.odeyeninAdi).sum(ofProperty: "miktar") ?? 0
        lblToplamOdeme.text = "Toplam Ödeme:\(toplamOdeme)TL"    }

    
}
