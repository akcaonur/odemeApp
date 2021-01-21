//
//  Aktiviteler.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import UIKit
import RealmSwift

class Aktiviteler: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var aktiviteler : Results<Aktivite>?
    let realm = try? Realm()
    
    /*let plistDosyaAdi :String = "AktivitelerListesi.plist"
    let dosyaYolu = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("AktivitelerListesi.plist")*/

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        verileriYukle()

        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aktiviteler?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell(style: .default, reuseIdentifier: "aktiviteler")
        
        let sonuc : Int = aktiviteler?[indexPath.row].odemeler.sum(ofProperty: "miktar") ?? 0
        if let adi = aktiviteler?[indexPath.row].Adi{
            cell.textLabel?.text="\(adi)-\(sonuc)"
        }
        
        if aktiviteler?[indexPath.row].Bittimi ?? false{
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
       // aktiviteler[indexPath.row].Bittimi = !aktiviteler[indexPath.row].Bittimi
        //tableView.reloadData()// cellforat
        
        performSegue(withIdentifier: "odemeListesiSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "odemeListesiSegue"{
            
            let hedefVC = segue.destination as! odemeListesiVC
            
            if let seciliIndex = tableView.indexPathForSelectedRow {
                hedefVC.secilenAktivite = aktiviteler?[seciliIndex.row]
            }
            
        }
    }
    
    @IBAction func btnAktiviteEkle(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Aktivite Ekle", message: "Eklemek İstediğiniz Aktivite", preferredStyle: .alert)
        alertController.addTextField {
            txtAktiviteAdi in txtAktiviteAdi.placeholder="Aktivite Adı"
        }
        let ekleAction = UIAlertAction(title: "Ekle", style: .default){
            action in
            let txtAktiviteAdi = alertController.textFields![0]
            
            if !txtAktiviteAdi.text!.isEmpty{
                let b1 = Aktivite()
                b1.Adi=txtAktiviteAdi.text!
                self.verileriKaydet(aktivite:b1)
                
                
                
                self.tableView.reloadData()
            }
        }
        alertController.addAction(ekleAction)
        present(alertController, animated: true, completion: nil)
    }
    func verileriKaydet(aktivite:Aktivite){
        do {
            try realm?.write {
                realm?.add(aktivite)
            }
            
        }catch{
            
        }
        
        
    }
    func verileriYukle(){
        aktiviteler = realm?.objects(Aktivite.self)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        aktiviteler = aktiviteler?.filter("Adi CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "Adi", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            verileriYukle()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let silme = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Sil"){(action,indexPath)in
            
            
            
            
            if let silinecekAktivite = self.aktiviteler?[indexPath.row]{
                do{
                    try self.realm?.write{
                        self.realm?.delete(silinecekAktivite.odemeler)
                        self.realm?.delete(silinecekAktivite)
                        
                    }
                }catch{
                    
                }
            }
        }
        let odesme = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Ödeştik") {(action,indexPath) in
            if let aktivite = self.aktiviteler?[indexPath.row]{
                do{
                    try self.realm?.write {
                        aktivite.Bittimi = true
                    }
                }catch{
                    
                }
            }
        }
        odesme.backgroundColor = .green
        return [odesme,silme]
    }

}
