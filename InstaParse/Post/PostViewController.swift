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

    @IBAction func onShareTapped(_ sender: Any) {
        view.endEditing(true) // Dismiss Keyboard
        
        APIManager().createPost(withImage: pickedImage, caption: captionTextField.text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")
                    
                    self?.navigationController?.popViewController(animated: true) // return to previous view controller
                    
                case .failure(let error):
                    self?.showAlert(for: error)
                }
            }
        }
    }

    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true) // Dismiss Keyboard
    }

    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showAlert(for error: Error) {
        showAlert(description: error.localizedDescription)
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
                self?.showAlert() // Unable to cast to UIImage
                return
            }
            
            if let error = error {
                self?.showAlert(for: error)
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
