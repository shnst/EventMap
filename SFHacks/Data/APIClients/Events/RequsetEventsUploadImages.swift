//
//  RequsetEventsUploadImages.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import Alamofire
import UIKit

func uploadImagesAndData(params:[String : AnyObject]?, images: [UIImage], success: @escaping (() -> Void), failure: @escaping (() -> Void)) -> Void {
    let imageData: [Data] = images.map({  $0.jpegData(compressionQuality: 0.5)! })//UIImageJPEGRepresentation($0, 0.5)! })
    
    Alamofire.upload(multipartFormData: { multipartFormData in
        
        for (key, value) in params! {
            if let data = value.data(using: String.Encoding.utf8.rawValue) {
                multipartFormData.append(data, withName: key)
            }
        }
        for data in imageData {
            multipartFormData.append(data, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
        }
    },
                     to: kBaseURL + "events/api/register_images/", encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload
                                .validate()
                                .responseJSON { response in
                                    switch response.result {
                                    case .success(let value):
                                        print("responseObject: \(value)")
                                        success()
                                    case .failure(let responseError):
                                        print("responseError: \(responseError)")
                                        failure()
                                    }
                            }
                        case .failure(let encodingError):
                            print("encodingError: \(encodingError)")
                            failure()
                        }
    })
}
