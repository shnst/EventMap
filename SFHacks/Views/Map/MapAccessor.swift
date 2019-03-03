//
//  MapAccessor.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

class MapAccessor {
    static private weak var mapViewController: MapViewController?
    class func getMap() -> MapViewController? {
        return mapViewController
    }
    
    class func setMap(_ mapViewController: MapViewController?) {
        self.mapViewController = mapViewController
    }
}
