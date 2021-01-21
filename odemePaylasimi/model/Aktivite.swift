//
//  Aktivite.swift
//  odemePaylasimi
//
//  Created by batuhankarasu on 12.01.2021.
//

import Foundation
import RealmSwift

class Aktivite :Object {
    @objc dynamic var Adi : String = ""
    @objc dynamic var Bittimi:Bool = false
    let odemeler = List<Odeme>()
}
