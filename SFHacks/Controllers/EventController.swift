//
//  EventController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import Foundation

class EventController {
    func join(eventID: Int, success: @escaping (() -> Void), failure: @escaping ((HTTPURLResponse?, String) -> Void)) {
        let request = RequestEventsJoin(eventID: eventID)
        APIClient.request(request: request).success { response in
            success()
            }.failure { error in
                switch error.error! {
                case .error(let httpResponse, let errorMessage):
                    failure(httpResponse, errorMessage)
                }
        }
    }
    
    func fetch(eventID: Int, success: @escaping ((_ event: EntityEvent) -> Void), failure: @escaping (() -> Void)) {
        let request = RequestEventsFetch(eventID: eventID)
        APIClient.request(request: request).success { response in
            guard let eventEntity = response else {
                failure()
                return
            }
            success(eventEntity)
            }.failure { error in
                failure()
        }
    }
}
