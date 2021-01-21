//
//  Odeme.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import Foundation
import RealmSwift

class Odeme : Object {
    @objc dynamic var odeyeninAdi:String = ""
    @objc dynamic var aciklama:String = ""
    @objc dynamic var miktar:Int = -1
    var aktivite = LinkingObjects(fromType: Aktivite.self,property:"odemeler")
}
