//
//  EntityLocation.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import RealmSwift
import ObjectMapper
import GoogleMaps

class EntityLocation: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    /// Computed properties are ignored in Realm
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude)
            
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["coordinate"]
    }
    
    required convenience init?(map: Map) {
        self.init()
        
        mapping(map: map)
    }
}

extension EntityLocation: Mappable {
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
