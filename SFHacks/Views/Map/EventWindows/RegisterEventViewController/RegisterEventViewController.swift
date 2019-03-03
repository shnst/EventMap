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
    
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var images: [UIImage] = []
    
    fileprivate var onEventGenreSelected: ((_ eventGenre: EventGenre.Tuple) -> Void)!
    fileprivate var registerEvent: ((_ event: EntityEvent, _ completion: @escaping (() -> Void)) -> Void)!
    fileprivate var onClosed: (() -> Void)!
    
    @IBOutlet private weak var shopNameTextField: UITextField!
    @IBOutlet private weak var menuTextView: UITextView!
    
    @IBOutlet fileprivate weak var shopPhotosContainer: UIView!
    @IBOutlet fileprivate weak var photoButtonContainer: IBDesignableView!
    @IBOutlet fileprivate weak var photoContainer: UIView!
    
    @IBOutlet fileprivate weak var startDatePickerButton: DatePickerButton!
    @IBOutlet fileprivate weak var endDatePickerButton: DatePickerButton!
    
    @IBOutlet fileprivate weak var eventImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
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
    
    fileprivate func updatePhotos() {
        if images.isEmpty {
            shopPhotosContainer.bringSubviewToFront(photoButtonContainer)
            photoButtonContainer.isHidden = false
            photoContainer.isHidden = true
        } else {
            shopPhotosContainer.sendSubviewToBack(photoButtonContainer)
            photoButtonContainer.isHidden = true
            photoContainer.isHidden = false
            eventImageView.image = images.first
        }
    }
    
    private func register() {
        guard shopNameTextField.text?.isEmpty == false else { return }
        guard startDatePickerButton.currentDate < endDatePickerButton.currentDate else { return }
        
        let newEvent = EntityEvent()
        
        let entityLocation = EntityLocation()
        entityLocation.coordinate = coordinate
        newEvent.coordinate = entityLocation
        newEvent.eventType = .commerce
        newEvent.name = shopNameTextField.text!
        newEvent.description1 = menuTextView.text!
        newEvent.description2 = "description2"
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
