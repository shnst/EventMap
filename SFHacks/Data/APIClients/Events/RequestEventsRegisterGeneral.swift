//
//  RequestEventsRegisterGeneral.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestEventsRegisterGeneral : CustomRequest {
    var name: String
    var description1: String
    var description2: String
    var longitude: Float
    var latitude: Float
    var startDate: Date
    var endDate: Date
    var genre: Int
    
    //MARK: Protocol
    typealias ResponseComponent = EntityEvent
    typealias Response = ResponseComponent
    
    var method : Method {
        return .post
    }
    
    var path : String {
        return "events/api/register_general/"
    }
    
    var parameters : [String : AnyObject] {
        return [
            "name" : name as AnyObject,
            "description1" : description1 as AnyObject,
            "description2" : description2 as AnyObject,
            "longitude" : longitude as AnyObject,
            "latitude" : latitude as AnyObject,
            "start_at" : startDate.toTimestamp() as AnyObject,
            "end_at" : endDate.toTimestamp() as AnyObject,
            "genre" : genre as AnyObject,
        ]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}
