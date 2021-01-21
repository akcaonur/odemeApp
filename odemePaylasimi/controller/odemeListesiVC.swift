//
//  odemeListesiVC.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import UIKit
import RealmSwift

class odemeListesiVC: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var odemeListesi : Results<Odeme>?
    
    var secilenAktivite : Aktivite? {
        didSet {
            odemeleriYukle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return odemeListesi?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "odemeCell", for: indexPath)
        if let odeme = odemeListesi?[indexPath.row]{
            hucre.textLabel?.text = "\(odeme.odeyeninAdi)-- \(odeme.miktar)Lira"
        }else{
            hucre.textLabel?.text = "henüz ödeneme bulunamadı"
        }
        return hucre
    }

   
    @IBAction func btnOdemeEkleClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Ödeme", message: "Ödeme Ekle", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField {txtKisiAdi in txtKisiAdi.placeholder = "Ödeyen Kişi"}
        alertController.addTextField {txtAciklama in txtAciklama.placeholder = "Açıklama"}
        alertController.addTextField {txtUcret in txtUcret.placeholder = "Ücret"
            txtUcret.keyboardType = .numberPad
        }
        let add = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default){action in
            let txtKisi = alertController.textFields![0]
            let txtAciklama = alertController.textFields![1]
            let txtUcret = alertController.textFields![2]
            
            if let secilenAktivite = self.secilenAktivite{
                do {
                    try self.realm.write {
                        let yeniOdeme = Odeme()
                        yeniOdeme.odeyeninAdi = txtKisi.text ?? "girilmedi"
                        yeniOdeme.aciklama = txtAciklama.text ?? "girilmedi"
                        yeniOdeme.miktar = Int(txtUcret.text ?? "-1")!
                        secilenAktivite.odemeler.append(yeniOdeme)
                    }
                    
                }catch {
                    print("ödemede hata \(error.localizedDescription)")
            
                }
            }
            self.tableView.reloadData()
            
            
        }
        alertController.addAction(add)
        present(alertController, animated: true, completion: nil)
        }
    func odemeleriYukle(){
        odemeListesi = secilenAktivite?.odemeler.sorted(byKeyPath: "odeyeninAdi", ascending: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "odemeDuzenleSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "odemeDuzenleSegue"{
            let hedefVC = segue.destination as! OdemeDuzenle
            if let seciliIndex = tableView.indexPathForSelectedRow{
                if let secilenOdeme = odemeListesi?[seciliIndex.row]{
                    hedefVC.secilenOdeme = secilenOdeme
                    hedefVC.title = "\(secilenOdeme.odeyeninAdi)Ödeme Bilgileri"
                    hedefVC.secilenAktivite = secilenAktivite
                }
            }
        }
     
        
    }
    override func viewWillAppear(_ animated: Bool){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let secilenOdeme = odemeListesi?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(secilenOdeme)
                }
            }catch{
                
            }
                
            }
        }
        tableView.reloadData()
    }
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        if odemeListesi?.count == 0{
            odemeleriYukle()
        }
        
        odemeListesi = odemeListesi?.filter("odeyeninAdi == %@",searchBar.text!).sorted(byKeyPath: "miktar", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            odemeleriYukle()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
