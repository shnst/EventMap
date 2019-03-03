//
//  EventGenre.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

class EventGenre {
    // name, id, image
    typealias Tuple = (name: String, id: Int, image: UIImage)
    static let kGenres: [Tuple] = [
        (name: "hamburger", id: 0, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 1, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 2, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 3, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 4, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 5, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 6, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 7, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 8, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 9, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 10, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 11, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        (name: "hamburger", id: 12, image: #imageLiteral(resourceName: "event.genre.iconhamburger")),
        ]
    
    class func genreFrom(id: Int) -> Tuple? {
        return kGenres.filter({ $0.id == id }).first
    }
}
