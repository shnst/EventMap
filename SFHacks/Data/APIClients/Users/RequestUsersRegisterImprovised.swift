//
//  RequestUsersRegisterImprovised.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestUsersRegisterImprovised : CustomRequest {
    
    //MARK: Protocol
    typealias ResponseComponent = ResponseUserRegisterImprovised
    typealias Response = ResponseComponent
    
    var method : Method {
        return .get
    }
    
    var path : String {
        return "users/api/sign_up_improvised/"
    }
    
    var HTTPHeaderFields: [String : String] {
        return [:]
    }
    
    var parameters : [String : AnyObject] {
        return [:]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}

struct ResponseUserRegisterImprovised: Mappable {
    let token: String
    let userName: String
    
    init?(map: Map) {
        do {
            token = try map.value("token")
            userName = try map.value("username")
        } catch {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        token   >>> map["token"]
        userName >>> map["username"]
    }
}
