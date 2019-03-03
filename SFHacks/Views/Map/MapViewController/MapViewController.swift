//
//  MapViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var searchBarContainer: UIView!
    
    //緯度経度 -> 金沢駅
    private let latitude: CLLocationDegrees = 35.691638
    private let longitude: CLLocationDegrees = 139.704616
    
    fileprivate var eventListController: EventListController!
    fileprivate var onMarkerTapped: ((_ event: EntityEvent) -> Void)!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var onCameraAnimationFinished: (() -> Void)?
    
    fileprivate var markerList: [GMSMarker] = []
    
    fileprivate var resultsViewController: GMSAutocompleteResultsViewController!
    fileprivate var searchController: UISearchController!
    
    fileprivate var viewHasAppeared: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setCameraToSelfLocation()
        searchBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewHasAppeared == false {
            viewHasAppeared = true
            setupSearchBar()
        }
    }
    
    func searchBarView() {
        self.searchBarContainer.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.91)
        self.searchBarContainer.layer.opacity = 5
        self.searchBarContainer.layer.shadowColor = UIColor.gray.cgColor
        self.searchBarContainer.layer.shadowRadius = 20
        self.searchBarContainer.layer.shadowOffset = CGSize(width: 3, height: 10)
        self.searchBarContainer.layer.cornerRadius = 18
        
    }

    
    func setup(
        eventListController: EventListController,
        onMarkerTapped: @escaping ((_ event: EntityEvent) -> Void)
        ) {
        self.eventListController = eventListController
        self.onMarkerTapped = onMarkerTapped
    }
    
    private func setupMap() {
        // ズームレベル.
        let zoom: Float = 15
        
        // カメラを生成.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: zoom)
        // MapViewにカメラを追加.
        mapView.camera = camera
        
        mapView.delegate = self
    }
    
    private func setCameraToSelfLocation() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            p("\(className) updatingLocation start1")
        }
    }
    
    func getAddress(screenCoordinate: CGPoint, result: @escaping ((_ address: GMSAddress?) -> Void)) {
        let coordinate = mapView.projection.coordinate(for: screenCoordinate)
        
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            result(response?.firstResult())
        }
    }
    
    func getAddress(coordinate: CLLocationCoordinate2D, result: @escaping ((_ address: GMSAddress?) -> Void)) {
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            result(response?.firstResult())
        }
    }
    
    func getCoordinate(screenCoordinate: CGPoint) -> CLLocationCoordinate2D {
        return mapView.projection.coordinate(for: screenCoordinate)
    }
    
    func moveCamera(screenCoordinate: CGPoint, completion: (() -> Void)?) {
        let destinationScreenCenter = CGPoint(x: screenCoordinate.x, y: screenCoordinate.y - (view.frame.height / 2 - 20))
        let location = mapView.projection.coordinate(for: destinationScreenCenter)
        mapView.animate(toLocation: location)
        onCameraAnimationFinished = completion
    }
    
    func reloadEventList() {
        eventListController.fetchEvents(location: mapView.projection.coordinate(for: mapView.center)) { [weak self] events in
            guard let sself = self else { return }
            p("\(sself.className) reloadEventList events=\(events)")

            // clear existing markers
            for marker in sself.markerList {
                marker.map = nil
            }
            for event in events {
                let marker: GMSMarker = GMSMarker()
                marker.position.latitude = event.coordinate!.latitude
                marker.position.longitude = event.coordinate!.longitude
                marker.map = sself.mapView

                let markerView = MarkerView.instantiate()
                markerView.setup(event: event)
                marker.iconView = markerView
                sself.markerList.append(marker)
            }
        }
    }
    
    private func setupSearchBar() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.delegate = self
        
        searchBarContainer.addSubview((searchController?.searchBar)!)
        
//        let widthConstraint = NSLayoutConstraint(item: searchController!.searchBar, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: searchBarContainer.frame.width)
//        let heightConstraint = NSLayoutConstraint(item: searchController!.searchBar, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: searchBarContainer.frame.height)
//        searchController!.searchBar.addConstraints([widthConstraint, heightConstraint])
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.frame.size = searchBarContainer.frame.size
        searchController?.searchBar.frame.origin = CGPoint(x: 0, y: 0)
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.91)
        searchController?.searchBar.layer.opacity = 2
        searchController?.searchBar.layer.shadowColor = UIColor.gray.cgColor
        searchController?.searchBar.layer.shadowRadius = 6
        searchController?.searchBar.layer.shadowOffset = CGSize(width: 3, height: 10)
        searchController?.searchBar.layer.cornerRadius = 18
        searchController?.searchBar.placeholder = "Find Events"

        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
  
}

extension MapViewController: UISearchControllerDelegate {

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        searchController?.searchBar.frame.origin = CGPoint(x: 0, y: 0)
        searchController?.searchBar.frame.size = searchBarContainer.frame.size
        super.didUpdateFocus(in: context, with: coordinator)
    }
    
    func didPresentSearchController(_ searchController: UISearchController)
    {
        searchController.searchBar.frame.origin = CGPoint(x: 0, y: 0)
        searchController.searchBar.frame.size = searchBarContainer.frame.size
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        searchController.searchBar.frame.origin = CGPoint(x: 0, y: 0)
        searchController.searchBar.frame.size = searchBarContainer.frame.size
    }
}


extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        moveCamera(screenCoordinate: mapView.projection.point(for: marker.position)) { [unowned self] in
            guard let markerView = marker.iconView as? MarkerView else { return }
            self.onMarkerTapped(markerView.event)
        }
        return true
    }
    
    // called when programmatical camera animation finished
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        onCameraAnimationFinished?()
        onCameraAnimationFinished = nil
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocaion = manager.location?.coordinate else {
            p("\(className) didUpdateLocations failed to fetch location")
            return
        }
        
        // update camera coordinate
        mapView.camera = GMSCameraPosition.camera(withTarget: currentLocaion, zoom: mapView.camera.zoom)
        reloadEventList()
        
        p("\(className) updatingLocation stop location=\(currentLocaion)")
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
        // 許可を求めるコードを記述する（後述）
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
        // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
        // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            p("\(className) updatingLocation start2")
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            p("\(className) updatingLocation start3")
        }
    }
}

// Handle the user's selection.
extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        searchController?.searchBar.text = place.formattedAddress
        mapView.animate(toLocation: place.coordinate)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}




