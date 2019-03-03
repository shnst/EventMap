//
//  RequestEventsFetchAround.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestEventsFetchAround : CustomRequest {
    var longitude: Double
    var latitude: Double
    
    //MARK: Protocol
    typealias ResponseComponent = ResponseEventsFetchAround
    typealias Response = ResponseComponent
    
    var method : Method {
        return .get
    }
    
    var path : String {
        return "events/api/fetch_around/"
    }
    
    var parameters : [String : AnyObject] {
        return [
            "longitude" : longitude as AnyObject,
            "latitude" : latitude as AnyObject,
        ]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}

extension RequestEventsFetchAround {
    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        p("object=\(object)")
        guard let array = object as? NSArray else { return nil }
    
//        guard let objects = Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]) else { return nil }
//        return ResponseEventsFetchAround(events: objects)
        return ResponseEventsFetchAround(events: Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]))
    }
}

struct ResponseEventsFetchAround: Mappable {
    let events: [EntityEvent]
    
    init(events: [EntityEvent]) {
        self.events = events
    }
    
    init?(map: Map) {
        return nil
    }
    
    mutating func mapping(map: Map) {
    }
}
