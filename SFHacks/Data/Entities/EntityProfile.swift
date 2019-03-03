//
//  EntityProfile.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import RealmSwift

class EntityProfile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: ImageEntity?
    let wishList = List<EntityEvent>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func mine() -> EntityProfile {
        let realm = try! Realm()
        if let profile = realm.object(ofType: EntityProfile.self, forPrimaryKey: 0) {
            // found
            return profile
        }
        // not found
        let myProfile = EntityProfile(value: ["id":0])
        try! realm.write {
            realm.add(myProfile, update: false)
        }
        return myProfile
    }
}
