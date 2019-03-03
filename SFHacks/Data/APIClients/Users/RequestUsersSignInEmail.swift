//
//  RequestUsersSignInEmail.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

struct RequestUsersSignInEmail : CustomRequest {
    var email: String
    var password: String
    
    //MARK: Protocol
    typealias ResponseComponent = ResponseUsersSignInEmail
    typealias Response = ResponseComponent
    
    var method : Method {
        return .post
    }
    
    var path : String {
        return "users/api/sign_in_email/"
    }
    
    var HTTPHeaderFields: [String : String] {
        return [:]
    }
    
    var parameters : [String : AnyObject] {
        return [
            "email" : email as AnyObject,
            "password" : password as AnyObject
        ]
    }
    
    var allowEmptyResponse: Bool {
        return false
    }
}

struct ResponseUsersSignInEmail: Mappable {
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
