//
//  EventWindowViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import GoogleMaps

class EventWindowViewController: UIViewController {
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var markerImageView: UIImageView!
    @IBOutlet private weak var markerGenreImageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(vc: UIViewController, category: String) {
        setContentView(vc: vc)
        categoryLabel.text = category
    }
    
    func setAddress(address: GMSAddress) {
        p("\(className) setAddress address=\(address)")
        addressLabel.text = address.lines?.joined(separator: " ")
    }
    
    func setMarkerGenre(eventGenre: EventGenre.Tuple) {
        markerGenreImageView.image = eventGenre.image
    }
    
    private func setContentView(vc: UIViewController) {
        contentContainerView.addSubview(vc.view)
        vc.view.frame.size = contentContainerView.frame.size
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    @IBAction func onBackgroundTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: { [unowned self] in
        })
    }
    
}
