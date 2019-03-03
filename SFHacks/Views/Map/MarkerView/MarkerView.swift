//
//  MarkerView.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

class MarkerView: UIView {
    private(set) var event: EntityEvent!
    
    @IBOutlet private weak var eventGenreImageView: UIImageView!
    @IBOutlet private weak var markerImageView: UIImageView!

    func setup(event: EntityEvent) {
        self.event = event
//        eventGenreImageView.image = event.eventGenre.image
    }
}
