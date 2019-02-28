//
//  DetailedViewController.swift
//  PropertyList
//
//  Created by Ivan Ermak on 2/25/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newsName: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var newsNameEditField: UITextField!
    @IBOutlet var imageTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBAction func startsEdit(_ sender: Any?)
    {
        textField.clearsOnInsertion = true
        imageTapGesture.isEnabled = true
        editButton.title = "Finish edit"
        textField.isEditable = true
        newsName.isHidden = true
        newsNameEditField.isHidden = false
        
    }
    
    
    var image : UIImage?
    var dataToEdit : News?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (dataToEdit == nil){
            startsEdit(editButton)
        } else {
        
        newsNameEditField.isHidden = true
        imageView.image = image
        newsName.text = dataToEdit?.title
        textField.text = dataToEdit?.subtitle
        let date = Date()
        Date().toMillis()
        
        }
        // Do any additional setup after loading the view.
    }
    
 
    
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
extension DetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        textBox.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
    }
    
    //uiimagepicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoBox.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
}
