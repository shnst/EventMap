//
//  CustomRequest.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import ObjectMapper

public enum Method: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

protocol CustomRequest {
    associatedtype Response
    
    var baseURL : URL { get }
    var method : Method { get }
    var path : String { get }
    var parameters : [String : AnyObject] { get }
    var HTTPHeaderFields : [String : String] { get }
    var allowEmptyResponse: Bool { get }
    
    func isResponseEmpty(object: AnyObject) -> Bool
    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Response?
    func errorFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Error?
}

extension CustomRequest {
    var baseURL : URL {
        return URL(string: kBaseURL)!
    }
    
    var HTTPHeaderFields : [String : String] {
        let accessToken = UserDefaultsManager.get(.accessToken) as? String ?? ""
        return ["Authorization": "Token \(accessToken)"]
    }
    
    func errorFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Error? {
        return nil
    }
    
    func isResponseEmpty(object: AnyObject) -> Bool {
        if let dict = object as? Dictionary<String, Any> {
            return dict.isEmpty
        }
        if let ary = object as? Array<Any> {
            return ary.isEmpty
        }
        return false
    }
}

extension CustomRequest where Response:Mappable {
    
    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) -> Response? {
        p("object=\(object) urlResponse=\(URLResponse)")
        guard let object = object as? Dictionary<String, Any> else {
            return nil
        }
        guard let model = Mapper<Response>().map(JSONObject: object) else{
            return nil
        }
        return model
    }
}
