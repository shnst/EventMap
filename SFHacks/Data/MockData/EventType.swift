//
//  EventGenre.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

enum EventType: Int {
    case commerce = 1
    case social = 2
    
    init(rawValue: Int) {
        switch rawValue {
        case EventType.commerce.rawValue: self = .commerce
        case EventType.social.rawValue: self = .social
        default: self = .social
        }
    }
}
