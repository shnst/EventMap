//
//  EventInfoViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import SVProgressHUD

class EventInfoViewController: UIViewController {
    fileprivate var event: EntityEvent!
    fileprivate var onClosed: (() -> Void)!
    
    fileprivate var controller = EventController()
    
    @IBOutlet private weak var eventNameLabel: UILabel!
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    @IBOutlet fileprivate weak var visitorsCollectionView: UICollectionView!
    
    @IBOutlet fileprivate weak var beforeStartingPeriodContainer: UIView!
//    @IBOutlet fileprivate weak var afterStartingPeriodContainer: RemainingTimeView!
    @IBOutlet fileprivate weak var eventImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVisitorsCollectionView()
    }
    
    func setup(event: EntityEvent, onClosed: @escaping (() -> Void)) {
        self.event = event
        self.onClosed = onClosed
        
        fetchLatestEventInformation()
        updateUI()
    }
    
    private func fetchLatestEventInformation() {
        controller.fetch(
            eventID: event.id,
            success: { [weak self] event in
                guard let sself = self else { return }
                sself.event = event
                DispatchQueue.main.async { [weak self] in
                    guard let sself = self else { return }
                    sself.updateUI()
                }
            },
            failure: {
                AlertManager.showConnectionErrorAlert { [weak self] in
                    DispatchQueue.main.async { [weak self] in
                        guard let sself = self else { return }
                        sself.fetchLatestEventInformation()
                    }
                }
        })
    }
    
    private func setupVisitorsCollectionView() {
//        visitorsCollectionView.registerCell(ProfileCollectionViewCell.self)
//        let flowLayout = visitorsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.estimatedItemSize = CGSize(width: 36, height: 36)
    }
    
    private func updateUI() {
//        eventNameLabel.text = event.name
//        descriptionTextView.text = event.description1
//
//        eventImageView.image = event.images.first?.image
//        visitorsCollectionView.reloadData()
    }
    
    private func joinEvent() {
        SVProgressHUD.show()
        controller.join(
            eventID: event.id,
            success: { [weak self] in
                SVProgressHUD.dismiss()
                guard let sself = self else { return }
                sself.dismiss(animated: true, completion: { [weak self] in
                    guard let sself = self else { return }
                    sself.onClosed()
                })
            },
            failure: { error in
                SVProgressHUD.dismiss()
                AlertManager.showConnectionErrorAlertWithMessage(
                    title: error != nil ? error!.description : localizedString("通信エラー"),
                    retryTask: { [weak self] in
                        //                        guard let sself = self else { return }
                        //                        sself.joinEvent()
                })
        })
    }
    
    @IBAction func onVisitButtonTapped(_ sender: UIButton) {
        joinEvent()
    }
    
    @IBAction func onCancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: { [unowned self] in
            self.onClosed()
        })
    }
}

extension EventInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        p("\(className) didSelectItemAt indexPath=\(indexPath)")
    }
}

extension EventInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case visitorsCollectionView:
            return event.participants.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case visitorsCollectionView:
            return createVisitorsCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func createVisitorsCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        p("\(className) createVisitorsCollectionViewCell indexPath=\(indexPath)")
        let cell = collectionView.dequeueCell(ProfileCollectionViewCell.self, indexPath: indexPath)
        
        let profile = event.participants[indexPath.row]
        
        return cell
    }
}
