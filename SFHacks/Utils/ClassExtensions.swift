//
//  ClassExtensions.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

protocol NibInstantiatable {}
extension UIView: NibInstantiatable {}

extension NibInstantiatable where Self: UIView {
    static func instantiate(withOwner ownerOrNil: Any? = nil) -> Self {
        let nib = UINib(nibName: self.className, bundle: nil)
        return nib.instantiate(withOwner: ownerOrNil, options: nil)[0] as! Self
    }
}


extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let className = type.className
        register(UINib(nibName: className, bundle: nil), forCellWithReuseIdentifier: className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}

protocol StoryBoardHelper {}
extension StoryBoardHelper where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
    
    static func instantiate(storyboard: String) -> Self {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}
extension UIViewController: StoryBoardHelper {}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var day : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    var minute: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
}

extension UIApplication {
    class func EntranceViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return EntranceViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return EntranceViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return EntranceViewController(controller: presented)
        }
        return controller
    }
}

extension Date {
    func toTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter.string(from: self)
    }
    
    static fileprivate func formatDate(_ dateString: String, format: String) -> Date?{
        let f = DateFormatter()
        f.dateFormat = format
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = TimeZone(abbreviation: "UTC")
        
        return f.date(from: dateString)
    }
    
    static func formatDateFromString(_ dateString: String) -> Date {
        if let d = formatDate(dateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            return d
        } else if let d = formatDate(dateString, format: "yyyy-MM-dd'T'HH:mm:ssZ") {
            return d
        } else if let d = formatDate(dateString, format: "yyyy-MM-dd") {
            return d
        } else if let d = formatDate(dateString, format: "yyyy-MM-dd HH:mm:ss Z") {
            return d
        } else if let d = formatDate(dateString, format: "yyyy-MM-dd") {
            return d
        } else if let d = formatDate(dateString, format: "yyyy-MM-dd HH:mm:ss") {
            return d
        }
        
        p("INVALID DATE FORMAT = \(dateString)")
        return Date()
    }
}
