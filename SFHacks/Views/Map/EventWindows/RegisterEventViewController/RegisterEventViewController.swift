//
//  RegisterEventViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import GoogleMaps

class RegisterEventViewController: UIViewController {
    fileprivate var coordinate: CLLocationCoordinate2D!
    
    fileprivate var selectedEventGenre: EventGenre.Tuple?
    
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var images: [UIImage] = []
    
    fileprivate var onEventGenreSelected: ((_ eventGenre: EventGenre.Tuple) -> Void)!
    fileprivate var registerEvent: ((_ event: EntityEvent, _ completion: @escaping (() -> Void)) -> Void)!
    fileprivate var onClosed: (() -> Void)!
    
    @IBOutlet fileprivate weak var eventGenreCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var photoCollectionView: UICollectionView!
    
    @IBOutlet private weak var shopNameTextField: UITextField!
    @IBOutlet private weak var promotionTextField: UITextField!
    @IBOutlet private weak var menuTextView: UITextView!
    
    @IBOutlet fileprivate weak var shopPhotosContainer: UIView!
    @IBOutlet fileprivate weak var photoButtonContainer: IBDesignableView!
    
    @IBOutlet fileprivate weak var startDatePickerButton: DatePickerButton!
    @IBOutlet fileprivate weak var endDatePickerButton: DatePickerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        
        updatePhotos()
    }
    
    func setup(
        coordinate: CLLocationCoordinate2D,
        onEventGenreSelected: @escaping ((_ eventGenre: EventGenre.Tuple) -> Void),
        registerEvent: @escaping ((_ event: EntityEvent, _ completion: @escaping (() -> Void)) -> Void),
        onClosed: @escaping (() -> Void)
        ){
        self.coordinate = coordinate
        self.onEventGenreSelected = onEventGenreSelected
        self.registerEvent = registerEvent
        self.onClosed = onClosed
    }
    
    fileprivate func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
//        // eventGenreCollectionView
//        eventGenreCollectionView.registerCell(EventGenreCollectionViewCell.self)
//        let flowLayout = eventGenreCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.estimatedItemSize = CGSize(width: 36, height: 36)
//
//        // photoCollectionView
//        photoCollectionView.registerCell(EventPhotoCollectionViewCell.self)
//        photoCollectionView.registerCell(SelectPhotoCollectionViewCell.self)
//        let flowLayout1 = photoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout1.estimatedItemSize = CGSize(width: 84, height: 44)
    }
    
    fileprivate func updatePhotos() {
//        delay(2.0) { [unowned self] in
//            self.photoCollectionView.reloadData()
//        }
//        
//        if images.isEmpty {
//            shopPhotosContainer.bringSubviewToFront(photoButtonContainer)
//            photoButtonContainer.isHidden = false
//            photoCollectionView.isHidden = true
//        } else {
//            shopPhotosContainer.sendSubviewToBack(photoButtonContainer)
//            photoButtonContainer.isHidden = true
//            photoCollectionView.isHidden = false
//        }
    }
    
    private func register() {
        guard let eventGenre = selectedEventGenre else { return }
        guard shopNameTextField.text?.isEmpty == false else { return }
        guard promotionTextField.text?.isEmpty == false else { return }
        guard startDatePickerButton.currentDate < endDatePickerButton.currentDate else { return }
        
        let newEvent = EntityEvent()
        
        let entityLocation = EntityLocation()
        entityLocation.coordinate = coordinate
        newEvent.coordinate = entityLocation
        newEvent.eventType = .commerce
        newEvent.eventGenre = eventGenre.id
        newEvent.name = shopNameTextField.text!
        newEvent.description1 = promotionTextField.text!
        newEvent.description2 = menuTextView.text!
        for image in images {
            let imageEntity = ImageEntity()
            imageEntity.image = image
            newEvent.images.append(imageEntity)
        }
        newEvent.startDate = startDatePickerButton.currentDate
        newEvent.endDate = startDatePickerButton.currentDate
        newEvent.organizer = ProfileController().getMine()
        
        registerEvent?(newEvent) { [unowned self] in
            MapAccessor.getMap()?.reloadEventList()
            self.dismiss(animated: true, completion: { [unowned self] in
                self.onClosed()
            })
        }
    }
    
    @IBAction private func onPayButtonTapped(_ sender: UIButton) {
        register()
    }
    
    @IBAction private func onCancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: { [unowned self] in
            self.onClosed()
        })
    }
    
    @IBAction private func onPhotoButtonTapped(_ sender: UIButton) {
        showImagePicker()
    }
}

extension RegisterEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        p("\(className) didSelectItemAt indexPath=\(indexPath)")
        switch collectionView {
        case eventGenreCollectionView:
            guard indexPath.row < EventGenre.kGenres.count else { return }
            selectedEventGenre = EventGenre.kGenres[indexPath.row]
            onEventGenreSelected?(selectedEventGenre!)
            collectionView.reloadData()
            
            photoCollectionView.reloadData()
        case photoCollectionView:
            if indexPath.row == 0 {
                showImagePicker()
            }
        default:
            break
        }
    }
}

extension RegisterEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case eventGenreCollectionView:
            return EventGenre.kGenres.count
        case photoCollectionView:
            // +1 is for a camera button
            p("\(className) numberOfItemsInSection photoCollectionView=\(1 + images.count)")
            return 1 + images.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case eventGenreCollectionView:
            return createEventGenreCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        case photoCollectionView:
            p("\(className) cellForItemAt indexPath=\(indexPath)")
            if indexPath.row == 0 {
                return createSelectPhotoCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
            } else {
                return createPhotoCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    private func createSelectPhotoCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
//        return collectionView.dequeueCell(SelectPhotoCollectionViewCell.self, indexPath: indexPath)
        return UICollectionViewCell()
    }
    
    private func createPhotoCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        p("\(className) createPhotoCollectionViewCell indexPath=\(indexPath)")
//        let image = images[indexPath.row - 1]
//        let cell = collectionView.dequeueCell(EventPhotoCollectionViewCell.self, indexPath: indexPath)
//        cell.setup(image: image)
//        return cell
        return UICollectionViewCell()
    }
    
    private func createEventGenreCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
//        guard indexPath.row < EventGenre.kGenres.count else { return UICollectionViewCell() }
//        let cell = collectionView.dequeueCell(EventGenreCollectionViewCell.self, indexPath: indexPath)
//        let genre = EventGenre.kGenres[indexPath.row]
//        cell.setup(eventGenre: genre, isSelected: selectedEventGenre == nil ? false : genre == selectedEventGenre!)
//
//        return cell
        return UICollectionViewCell()
    }
}

extension RegisterEventViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //selectedPhotoButton?.setImage(image, for: .normal)
            images.append(image)
        } else{
            p("\(className) didFinishPickingImage Something went wrong")
        }
        
        dismiss(animated: true, completion: { [unowned self] in
            self.updatePhotos()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterEventViewController: UINavigationControllerDelegate {
    
}
