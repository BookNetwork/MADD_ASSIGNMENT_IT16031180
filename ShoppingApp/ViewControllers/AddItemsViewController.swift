//
//  AddItemsViewController.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/17/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

protocol AddItemsViewControllerDelegate  {
    func didAddOrUpdateItem(itemAdded: Bool)
}


class AddItemsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtTitle: CustomTextField!
    @IBOutlet weak var txtDescription: CustomTextField!
    @IBOutlet weak var txtPrice: CustomTextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: Variables
    var delegate: AddItemsViewControllerDelegate!
    var selectedImageData: Data = Data()
    var isImageSelected = false
    
    

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderColor = UIColor(hexString: "#BFD730")?.cgColor
        imageView.layer.borderWidth = 1.0
    }
    
    
    //MARK: Actions
    @IBAction func pressedSelectImage(_ sender: Any) {
        openImageOptions()
    }
    
    @IBAction func pressedSaveItem(_ sender: Any) {
        saveItem()
    }
    
    
    //MARK: Functions
    func showOkAlert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        if (txtTitle.text?.isEmpty == false) && (txtDescription.text?.isEmpty == false) && (txtPrice.text?.isEmpty == false) {
            //save to realm local DB
            saveToRealm()
            
            //navigate to sellers home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.delegate.didAddOrUpdateItem(itemAdded: true)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showOkAlert(title: "Alert", body: "Please add item details to save")
        }
    }
    
    func saveToRealm() {
        let realm = try! Realm()
        
        try! realm.write {
            let saveItems = Items()
            saveItems.id = saveItems.incrementId()
            saveItems.title = txtTitle.text ?? ""
            saveItems.itemDesc = txtDescription.text ?? ""
            saveItems.itemPrice = txtPrice.text ?? ""
            
            if isImageSelected {
                saveItems.image = selectedImageData
            }
            
            realm.add(saveItems)
            print("saved Successfully")
        }
    }
    

}


extension AddItemsViewController {
    
    //common function for
    var picker : UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.isTranslucent = false
        return imagePicker
    }
    
    //function for camera access validation and show camera
    func showCameraActionSheet(_ actionSheet: UIAlertController) {
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) -> Void in
            //checking the request acess permision to the camera
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                //if permission granted means
                if granted {
                    let picker = self.picker
                    picker.sourceType = .camera
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }
        actionSheet.addAction(cameraAction)
    }
    
    //function for photo library access
    func showPhotoLibraryActionSheet(_ actionSheet: UIAlertController) {
        
        let libraryAction = UIAlertAction(title: "Choose Album", style: .default) { (_) -> Void in
            let picker = self.picker
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        actionSheet.addAction(libraryAction)
    }
    
    //function for cancel action
    func addCancelAction(_ actionSheet: UIAlertController) {
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (_) -> Void in
        }
        actionSheet.addAction(cancelAction)
    }
    
    func openImageOptions() {
        let actionSheet = UIAlertController(title: "Upload Item Image", message: nil, preferredStyle: .actionSheet)
        self.showCameraActionSheet(actionSheet)
        self.showPhotoLibraryActionSheet(actionSheet)
        self.addCancelAction(actionSheet)
        present(actionSheet, animated: true, completion: nil)
    }
    
}


//extension for delegates
extension AddItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let choosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = choosenImage
            if let data = choosenImage.jpegData(compressionQuality: 0.5) {
                self.selectedImageData = data
            }
            isImageSelected = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
