//
//  OdemeDuzenleVC.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import UIKit
import RealmSwift

class OdemeDuzenleVC: UIViewController {

    var secilenAktivite : Aktivite?
    var secilenOdeme : Odeme?
    let realm = try! Realm()
    
   
    
    
    @IBOutlet weak var txtUcret: UITextField!
    
    @IBOutlet weak var txtAciklama: UITextField!
    @IBOutlet weak var txtOdemeKisiAdi: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gorunumuAyarla()
    }
    @IBAction func btnGuncelleClicked(_ sender: Any) {
            
            if let secilenOdeme = secilenOdeme{
                do{
                    try realm.write{
                        secilenOdeme.odeyeninAdi = txtOdemeKisiAdi.text!
                        secilenOdeme.aciklama = txtAciklama.text!
                        secilenOdeme.miktar = Int((txtUcret.text)!)!
                        
                        
                        print("ödeme başarıyla tamamlandı")
                    }
                }catch{
                    print("ödeme güncellenirken hata oldu:\(error.localizedDescription)")
                    
                }
            }
        }
    
    
    func gorunumuAyarla(){
        txtOdemeKisiAdi.text = secilenOdeme?.odeyeninAdi
        txtAciklama.text = secilenOdeme?.aciklama
        txtUcret.text = "\(secilenOdeme!.miktar)"
        
    }

    
}
