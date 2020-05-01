//
//  AddClubViewController.swift
//  Pivot
//
//  Created by Silvi Kabra on 4/13/20.
//  Copyright © 2020 Silvi Kabra. All rights reserved.
//

import UIKit


class AddClubViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  
    
    
    @IBOutlet var clubNameLabel: UILabel!
    @IBOutlet var positionNameLabel: UILabel!
    @IBOutlet var dateStartedLabel: UILabel!
    @IBOutlet var clubNameTextField: UITextField!
    @IBOutlet var positionNameTextField: UITextField!
    @IBOutlet var dateStartedTextField: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet var clubImageView: UIImageView!
    @IBOutlet var saveButton : UIButton!
    
    weak var delegate: AddClubDelegate?
    
    
    @IBAction func didSelectSave(_ sender: UIButton) {
        performSegue(withIdentifier: "linkAppsToClubSegue", sender: nil)
    }
    
    @IBAction func didSelectCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkAppsToClubSegue" {
                if let addClubAccessesVC = segue.destination as? AddClubAccessesViewController {                addClubAccessesVC.delegate = delegate
                    addClubAccessesVC.name = clubNameTextField.text
                    addClubAccessesVC.position = positionNameTextField.text
                    addClubAccessesVC.dateStarted = datePicker.date
                    addClubAccessesVC.clubIcon = clubImageView.image
                
            }
            print(segue.destination)
        }
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickingDate))
        let middleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPickingDate))
        toolbar.setItems([cancelButton, middleButton, doneButton], animated: false)
        dateStartedTextField.inputAccessoryView = toolbar
        dateStartedTextField.inputView = datePicker
    }
    
    @objc func donePickingDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateStartedTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelPickingDate() {
        self.view.endEditing(true)
    }
    
    @objc func enableSaveButton() {
        if clubNameTextField.text != nil && clubNameTextField.text != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func clubImagePressed(_ sender: UIGestureRecognizer) {
           presentAlertController()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                clubImageView.image = selectedImage
                dismiss(animated: true, completion: nil)
            }
    }
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Image Source", message: "Pick an image source for this club picture", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Secondary option"), style: .default) {action in self.presentImagePicker(source: .camera)})
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Default action"), style: .default) {action in self.presentImagePicker(source: .photoLibrary)})
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "This source type is not available on this device", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showDatePicker()
        clubNameTextField.addTarget(self, action: #selector(enableSaveButton), for: .editingChanged)
        clubImageView.backgroundColor = UIColor.systemGray2
        clubImageView.contentMode = .scaleAspectFill
        clubImageView.layer.cornerRadius = clubImageView.frame.width/2
        clubImageView.clipsToBounds = true
        
    }
    
    


}
