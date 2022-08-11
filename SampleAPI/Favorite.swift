//
//  Favorite.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/11.
//

import Foundation
import RealmSwift

class Favorite: Object {
    @objc dynamic var id = 0

    @objc dynamic var pokeDexID = ""

    @objc dynamic var enName = ""

    @objc dynamic var jaName = ""

    @objc dynamic var image = Data()

    override static func primaryKey() -> String? {
        return "id"
    }
}
