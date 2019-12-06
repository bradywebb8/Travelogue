//
//  NoteDetailTableViewController.swift
//  TravelogProject
//
//  Created by Brady Webb on 12/5/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit

class NoteDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newNoteDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var note: Note?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        bodyTextView.layer.cornerRadius = 6.0
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        newNoteDateFormatter.dateStyle = .medium
        
        if let note = note
        {
            titleTextField.text = note.title
            bodyTextView.text = note.body
            if let addDate = note.addDate
            {
                dateLabel.text = dateFormatter.string(from: addDate)
            }
            image = note.image
            imageView.image = image
        } else
        {
            titleTextField.text = ""
            bodyTextView.text = ""
            dateLabel.text = newNoteDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            imageView.image = nil
        }
    }

    @IBAction func selectImage(_ sender: Any)
    {
        selectImageSource()
    }

    func selectImageSource()
    {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler:
            {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler:
            {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera()
    {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "No camera availuable.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary()
    {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        defer
        {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            return
        }
        image = selectedImage
        imageView.image = image
        if let note = note {
            note.image = selectedImage
        }
    }
    
    func alertNotifyUser(message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any)
    {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else
        {
            alertNotifyUser(message: "Please enter a title.")
            return
        }
        if let note = note
        {
            note.title = title
            note.body = bodyTextView.text
            note.image = image

        } else
        {
            note = Note(title: title, body: bodyTextView.text, image: image)
        }
        if let note = note
        {
            do
            {
                let managedContext = note.managedObjectContext
                try managedContext?.save()
            } catch
            {
                alertNotifyUser(message: "Your travel can't be saved.")
            }
            
        } else
        {
            alertNotifyUser(message: "Your travel can't be created.")
        }
        navigationController?.popViewController(animated: true)
    }
}
