//
//  GeneralEventViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import GoogleMaps

class GeneralEventViewController: UIViewController {
    
    private enum Segue: String {
        case registerNewEvent = "registerNewEvent"
        case seeInformation = "seeInformation"
    }
    
    private var registerEvent: ((_ event: EntityEvent, _ completion: @escaping (() -> Void)) -> Void)!
    
    private var initialMarkerCoordinate: CGPoint = CGPoint.zero
    private var hasViewAppeared: Bool = false
    
    private var markerSettledPoint: CGPoint?
    private var markerSettledCoordinate: CLLocationCoordinate2D?
    
    private var selectedEvent: EntityEvent?
    
    
    @IBOutlet private weak var mapMarkerContainer: UIView!
    @IBOutlet private weak var tabbarContainer: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.registerNewEvent.rawValue:
            let vc = segue.destination as! EventWindowViewController
            
            guard let markerSettledPoint = markerSettledPoint else { return }
            MapAccessor.getMap()?.getAddress(screenCoordinate: markerSettledPoint) { address in
                guard address != nil else { return }
                vc.setAddress(address: address!)
            }
            
            guard let markerSettledCoordinate = markerSettledCoordinate else { return }
            // to instantiate view before manipulating it
            _ = vc.view
            
            let registerEventViewController = RegisterEventViewController.instantiate()
            registerEventViewController.setup(
                coordinate: markerSettledCoordinate,
                onEventGenreSelected: { eventGenre in
                    vc.setMarkerGenre(eventGenre: eventGenre)
            }, registerEvent: { [unowned self] event, completion in
                self.registerEvent(event, completion)
                }, onClosed: { [unowned self] in
                    UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                        self.tabbarContainer.alpha = 1.0
                    })
            })
            vc.setup(vc: registerEventViewController, category: localizedString("Shops & Restaurants"))
            
            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.tabbarContainer.alpha = 0.0
            })
            break
        case Segue.seeInformation.rawValue:
            break
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if hasViewAppeared == false {
            hasViewAppeared = true
            initialMarkerCoordinate = mapMarkerContainer.frame.origin
        }
    }
    
    func setup(
        registerEvent: @escaping ((_ event: EntityEvent, _ completion: @escaping (() -> Void)) -> Void)
        ){
        self.registerEvent = registerEvent
    }
    
    func showEventInformationView(event: EntityEvent) {
        selectedEvent = event
        performSegue(withIdentifier: Segue.seeInformation.rawValue, sender: self)
    }
    
    @IBAction func onDraggedMarker(_ sender: UIPanGestureRecognizer) {
        guard let targetView = sender.view else { return }
        
        switch sender.state {
        case .ended:
            markerSettledPoint = CGPoint(x: targetView.center.x, y: targetView.frame.origin.y + targetView.frame.height)
            markerSettledCoordinate = MapAccessor.getMap()?.getCoordinate(screenCoordinate: markerSettledPoint!)
            
            MapAccessor.getMap()?.moveCamera(screenCoordinate: markerSettledPoint!) { [unowned self] in
                self.performSegue(withIdentifier: Segue.registerNewEvent.rawValue, sender: self)
            }
            
            // set to initial position
            targetView.frame.origin = initialMarkerCoordinate
        default:
            let move: CGPoint = sender.translation(in: view)
            targetView.center.x += move.x
            targetView.center.y += move.y
            
            sender.setTranslation(CGPoint.zero, in:view)
        }
    }
    
    @IBAction func onTimeFeedButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func onPlusButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func onWishListButtonTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: Segue.wishListViewController.rawValue, sender: self)
    }
    
    @IBAction func onSettingsButtonTapped(_ sender: UIButton) {
    }
}
