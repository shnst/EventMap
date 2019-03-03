//
//  APIClient.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import Alamofire
import SwiftTask

public enum APIError : Error {
    case error(HTTPURLResponse?)
}

struct APIClient {
    static func request<T : CustomRequest>(request : T) -> Task<Float, T.Response?, APIError> {
        
        let endPoint    = request.baseURL.absoluteString+request.path
        let params      = request.parameters
        let headers     = request.HTTPHeaderFields
        let method      = Alamofire.HTTPMethod(rawValue: request.method.rawValue) ?? .get
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : URLEncoding.default//JSONEncoding.default
        
        p("APIClient endpoint=\(endPoint) params=\(params)")
        
        let task = Task<Float, T.Response?, APIError> { progress, fulfill, reject, configure in
            let req = Alamofire.request(endPoint, method: method, parameters: params, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                //                .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                //                    if totalBytesExpectedToWrite != 0 {
                //                        let prog = Float(totalBytesWritten / totalBytesExpectedToWrite)
                //                        progress(prog)
                //                    }
                //                }
                .responseJSON(completionHandler: { response in
                    pAPIError(endPoint, response: response)
                    
                    if response.response != nil, (200 <= response.response!.statusCode && response.response!.statusCode < 300) {
                        // success
                        if let object = response.result.value, let URLResponse = response.response {
                            guard let model = request.responseFromObject(object: object as AnyObject, URLResponse: URLResponse) else {
                                if request.allowEmptyResponse {
                                    fulfill(nil)
                                    return
                                }
                                reject(.error(response.response))
                                return
                            }
                            fulfill(model)
                            return
                        }
                        
                        if request.allowEmptyResponse {
                            fulfill(nil)
                            return
                        }
                        reject(.error(response.response))
                        return
                    }
                    // failure
                    reject(.error(response.response))
                })
            
            print(req)
            print(req.debugDescription)
        }
        return task
    }
}
