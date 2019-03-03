//
//  MapBrowserViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

class MapBrowserViewController: UIViewController {
    
    private enum Segue: String {
        case embedMapViewController = "embedMapViewController"
        case embedGeneralEventViewController = "embedGeneralEventViewController"
    }
    
    private var mapViewController: MapViewController!
    private var generalEventViewController: GeneralEventViewController!
    fileprivate var eventListController: EventListController = EventListController()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.embedMapViewController.rawValue:
            mapViewController = (segue.destination as! MapViewController)
            mapViewController?.setup(
                eventListController: eventListController,
                onMarkerTapped: { [unowned self] event in
                    self.generalEventViewController.showEventInformationView(event: event)
            })
            MapAccessor.setMap(mapViewController)
        case Segue.embedGeneralEventViewController.rawValue:
            generalEventViewController = segue.destination as! GeneralEventViewController
            generalEventViewController.setup(
                registerEvent: { [unowned self] event, completion in
                    self.eventListController.registerEvent(event: event, completion: completion)
            })
        default:
            break
        }
    }
    
    deinit {
        MapAccessor.setMap(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapViewController.reloadEventList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
