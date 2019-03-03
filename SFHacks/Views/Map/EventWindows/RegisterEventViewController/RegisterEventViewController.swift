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
        menuTextView.placeholder = "Event Description"
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
        newEvent.endDate = endDatePickerButton.currentDate
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

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

extension RegisterEventViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
