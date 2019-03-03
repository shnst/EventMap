//
//  EntityEvent.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import RealmSwift
import GoogleMaps
import ObjectMapper

class EntityEvent: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var coordinate: EntityLocation?
    @objc dynamic var eventGenre: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var description1: String = ""
    @objc dynamic var description2: String = ""
    let images = List<ImageEntity>()
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var organizer: EntityProfile?
    let participants = List<EntityProfile>()
    
    var eventType: EventType {
        get {
            return EventType(rawValue: _eventType)
        }
        set {
            _eventType = eventType.rawValue
        }
    }
    @objc private dynamic var _eventType: Int = EventType.commerce.rawValue
    
    override static func ignoredProperties() -> [String] {
        return ["eventType"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        guard map.JSON["id"] != nil else { return nil }
        
        self.init()
        
        mapping(map: map)
    }
}

extension EntityEvent: Mappable {
    func mapping(map: Map) {
        p("EntityEvent mapping=\(map)")
        id <- map["id"]
        name <- map["name"]
        eventGenre <- map["genre"]
        description1 <- map["description1"]
        description2 <- map["description2"]
        
        if let dateString = map["start_at"].currentValue as? String {
            startDate = Date.formatDateFromString(dateString)
        }
        if let dateString = map["end_at"].currentValue as? String {
            endDate = Date.formatDateFromString(dateString)
        }
    
        if let imageArray = map["images"].currentValue as? NSArray {
            for imageDictionary in imageArray {
                if let image = imageDictionary as? NSDictionary {
                    let imageEntity = ImageEntity()
                    imageEntity.url = image["image"] as! String
                    images.append(imageEntity)
                }
            }
        }
        
        p("EntityEvent startDate=\(startDate) endDate=\(endDate) json=\(map.JSON)")
        
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        
        let entityLocation = EntityLocation()
        entityLocation.longitude = longitude
        entityLocation.latitude = latitude
        coordinate = entityLocation
    }
}

class ImageEntity: Object {
    var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = value.pngData()
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    @objc dynamic var url: String = ""
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: Data? = nil
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
}
