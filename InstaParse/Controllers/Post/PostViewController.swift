//
//  PostViewController.swift
//  InstaParse
//
//
//

import UIKit
import PhotosUI

class PostViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!

    private var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        // Create picker configuration
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current // no transcoding, get original file

        // Instantiate and present the picker
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    @IBAction func onTakePhotoTapped(_ sender: Any) {
        view.endEditing(true) // Dismiss Keyboard
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌ 📷 Camera not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true // allow crop etc.
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func onShareTapped(_ sender: Any) {
        view.endEditing(true) // Dismiss Keyboard
        
        APIManager().createPost(withImage: pickedImage, caption: captionTextField.text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post saved and user updated! \(post)")
                    
                    self?.navigationController?.popViewController(animated: true) // return to previous view controller
                    
                case .failure(let error):
                    Alert(self).showError(for: error)
                }
            }
        }
    }

    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true) // Dismiss Keyboard
    }
    
    private func imageToData() {}
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load item
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            guard let image = object as? UIImage else {
                Alert(self).showError() // Unable to cast to UIImage
                return
            }
            
            if let error = error {
                Alert(self).showError(for: error)
            } else {
                // Set image
                DispatchQueue.main.async {
                    self?.pickedImage = image
                    self?.previewImageView.image = image
                }
            }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] as? UIImage) 
//                    ?? (info[.originalImage] as? UIImage) // uncomment if picker configuration is unknown
        guard image != nil else {
            print("❌📷 Unable to get image")
            return
        }

        previewImageView.image = image
        pickedImage = image
    }
}
