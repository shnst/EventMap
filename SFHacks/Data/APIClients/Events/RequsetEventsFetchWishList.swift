//
//  RequsetEventsFetchWishList.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestEventsFetchWishList : CustomRequest {
    //MARK: Protocol
    typealias ResponseComponent = ResponseEventsFetchWishList
    typealias Response = ResponseComponent
    
    var method : Method {
        return .get
    }
    
    var path : String {
        return "events/api/fetch_wish_list/"
    }
    
    var parameters : [String : AnyObject] {
        return [:]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}

extension RequestEventsFetchWishList {
    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        p("object=\(object)")
        guard let array = object as? NSArray else {
            return Response(events: [EntityEvent]())
        }
//        guard let objects = Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]) else {
//            return Response(events: [EntityEvent]())
//        }
//        return Response(events: objects)
        return Response(events: Mapper<EntityEvent>().mapArray(JSONArray: array as! [[String : Any]]))
    }
}

struct ResponseEventsFetchWishList: Mappable {
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
