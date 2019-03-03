//
//  RequestEventsFetch.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestEventsFetch : CustomRequest {
    var eventID: Int
    
    //MARK: Protocol
    typealias ResponseComponent = EntityEvent
    typealias Response = ResponseComponent
    
    var method : Method {
        return .get
    }
    
    var path : String {
        return "events/api/fetch/"
    }
    
    var parameters : [String : AnyObject] {
        return [
            "event_id" : eventID as AnyObject
        ]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}
