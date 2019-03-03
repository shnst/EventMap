//
//  ScreenTransitionManager.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

class ScreenTransitionManager {
    private init() {}
    
    class func moveToMapBrowserViewController() {
        UIApplication.shared.delegate?.window!!.rootViewController = MapBrowserViewController.instantiate()
    }
}
