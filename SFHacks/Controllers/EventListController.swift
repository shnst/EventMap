//
//  EventListController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import GoogleMaps
import SVProgressHUD
import RealmSwift

class EventListController {
    
    func registerEvent(event: EntityEvent, completion: @escaping (() -> Void)) {
        SVProgressHUD.show()
        let request = RequestEventsRegisterGeneral(
            name: event.name,
            description1: event.description1,
            description2: event.description2,
            longitude: Float(event.coordinate!.longitude),
            latitude: Float(event.coordinate!.latitude),
            startDate: event.startDate,
            endDate: event.endDate,
            genre: event.eventGenre
        )
        
        p("startDate=\(event.startDate) endDate=\(event.endDate)")
        
        APIClient.request(request: request).success{ response in
            SVProgressHUD.dismiss()
            p("EventDataStoreImpl registerEvent response=\(String(describing: response))")
            let realm = try! Realm()
            try! realm.write {
                realm.add(response!, update: true)
            }
            
            completion()
            }.failure{ error in
                SVProgressHUD.dismiss()
                AlertManager.showConnectionErrorAlertCancellable(
                    title: localizedString("Failed to register the event."),
                    description: localizedString(""),
                    retryTask: { [weak self] in
                        guard let sself = self else { return }
                        sself.registerEvent(event: event, completion: completion)
                })
        }
    }
    
    func fetchEvents(location: CLLocationCoordinate2D, completion: @escaping ((_ events: [EntityEvent]) -> Void)) {
        p("EventListController::fetchEvents longitude=\(location.longitude) latitude=\(location.latitude)")
        SVProgressHUD.show()
        let request = RequestEventsFetchAround(
            longitude: location.longitude,
            latitude: location.latitude
        )
        APIClient.request(request: request).success{ response in
            SVProgressHUD.dismiss()
            p("EventDataStoreImpl registerEvent response=\(String(describing: response))")
            let realm = try! Realm()
//            let existingEvents = realm.objects(EntityEvent.self)
            try! realm.write {
//                realm.delete(existingEvents)
                for event in response!.events {
                    realm.add(event, update: true)
                }
            }
            p("events=\(response!.events)")
            completion(Array(realm.objects(EntityEvent.self)))
            }.failure{ error in
                SVProgressHUD.dismiss()
                AlertManager.showConnectionErrorAlertCancellable(
                    title: localizedString("Failed to fetch events."),
                    description: localizedString(""),
                    retryTask: { [weak self] in
                        guard let sself = self else { return }
                        sself.fetchEvents(
                            location: location,
                            completion: completion)
                })
        }
    }
}
