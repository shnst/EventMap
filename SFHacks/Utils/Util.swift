//
//  Util.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import Foundation
import Alamofire

func p<T>(_ object: T) {
    #if DEBUG
        print(object)
    #endif
}

func pAPIError(_ apiName: String, response: Alamofire.DataResponse<Any>) {
    #if DEBUG
        // show only error responses
        //        guard response.response?.statusCode != nil, response.response!.statusCode > 300  else {
        //            return
        //        }
        let statusCode: String = "\(String(describing: response.response?.statusCode))"
        var errorMessage: String = ""
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)

            if json != nil {
                errorMessage += json!
            }
        }
        print("API=\(apiName) statusCode=\(statusCode)  responseMessage=\(errorMessage)")
    #endif
}

func localizedString(_ text: String) -> String {
    return NSLocalizedString(text, comment:"")
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

func isEmailValid(text: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: text)
}

func isPasswordValid(text: String) -> (succeeded: Bool, error: String) {
    // 8文字以上かチェック
    if text.characters.count < 8 {
        return (false, "Password needs to contain more than 8 characters.")
    }
    
    // 英数字のみで構成されているかチェック
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9]*$", options: [.caseInsensitive])
    if regex.firstMatch(in: text, options:[], range: NSMakeRange(0, text.utf16.count)) == nil {
        return (false, "Password containds invalid character.")
    }
    
    // アルファベットを含んでいるかチェック
    let letters = CharacterSet.letters
    if text.rangeOfCharacter(from: letters) == nil {
        return (false, "Password needs to contain at least one alphabet.")
    }
    
    // 数字を含んでいるかチェック
    let decimalCharacters = CharacterSet.decimalDigits
    if text.rangeOfCharacter(from: decimalCharacters) == nil {
        return (false, "Password needs to contain at least one number.")
    }
    return (true, "")
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
