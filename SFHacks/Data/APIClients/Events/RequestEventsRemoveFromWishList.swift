//
//  RequestEventsRemoveFromWishList.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestEventsRemoveFromWishList : CustomRequest {
    var eventID: Int
    
    //MARK: Protocol
    typealias ResponseComponent = ResponseEventsRemoveFromWishList
    typealias Response = ResponseComponent
    
    var method : Method {
        return .post
    }
    
    var path : String {
        return "users/api/remove_from_wish_list/"
    }
    
    var parameters : [String : AnyObject] {
        return [
            "event_id" : eventID as AnyObject,
        ]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}

extension RequestEventsRemoveFromWishList {
    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        p("RequestEventsRemoveFromWishList responseFromObject object=\(object)")
        guard let array = object as? NSArray else {
            return Response(events: [EntityEvent]())
        }
        
//        guard let objects = Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]) else { return Response(events: [EntityEvent]())
//        }
//        return Response(events: objects)
        return Response(events: Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]))
    }
}

struct ResponseEventsRemoveFromWishList: Mappable {
    let events: [EntityEvent]
    
    init(events: [EntityEvent]) {
        self.events = events
    }
    
    init?(map: Map) {
        return nil
    }
    
    mutating func mapping(map: Map) {
        return
    }
}
