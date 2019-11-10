//
//  SelectionViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 11/8/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import UIKit

class SelectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var imagePicked: UIImage?;
    
    override func viewDidLoad() {
    }
    
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController();
               imagePicker.delegate = self
               imagePicker.sourceType = .camera
               imagePicker.allowsEditing = false
               self.present(imagePicker, animated: true)
        }
    }
    
    @IBAction func cameraRoll(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               let imagePicker = UIImagePickerController();
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "dropDetails") {
                let dropMediaController = segue.destination as! DropMediaViewController;
                dropMediaController.imageFromSelection = imagePicked
               
            }
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked = image
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "dropDetails", sender: self)
    }
}
