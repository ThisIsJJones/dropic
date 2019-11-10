//
//  DropMediaViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 11/5/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import UIKit

class DropMediaViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mediaNameTextField: UITextField!
//    @IBOutlet weak var detailedMessageTextView: UITextView!
    @IBOutlet weak var randomDropSwitch: UISwitch!
    @IBOutlet weak var imagePicked: UIImageView!
    var imageFromSelection: UIImage?;
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaNameTextField.delegate = self
        imagePicked.image = imageFromSelection
        
//        detailedMessageTextView!.layer.borderColor = UIColor.black.cgColor
//        detailedMessageTextView.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mediaLocationSegue") {
            print("media location segue")
            let mediaLocationController = segue.destination as! MediaLocationViewController;
            mediaLocationController.mediaName = mediaNameTextField.text!
//            mediaLocationController.message = detailedMessageTextView.text!
            mediaLocationController.isRandomDrop = randomDropSwitch.isOn
            mediaLocationController.image = imageFromSelection;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ((mediaNameTextField.text?.isEmpty)!) {
            return false;
        }
        return true;
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imagePicked.image = image
//        dismiss(animated: true, completion: nil)
//    }
    
    
}
