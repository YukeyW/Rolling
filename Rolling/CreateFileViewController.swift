//
//  CreateFileViewController.swift
//  Rolling
//
//  Created by yukey on 14/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

class CreateFileViewController: UIViewController {
    var imageList = [UIImage]()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.layer.borderColor = UIColor.opaqueSeparator.cgColor
            collectionView.layer.borderWidth = 1
        }
    }
    
    @objc func didTapCell(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cell = collectionView.layoutAttributesForItem(at: [0,imageList.count])
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(imagePicker: imagePickerController, sourceType: .camera) }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(controller: imagePickerController, source: .photoLibrary) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = self.collectionView;
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell?.bounds.midX ?? 0, y: cell?.bounds.midY ?? 0, width: 0, height: 0)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func openCamera(imagePicker: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            presentImagePicker(controller: imagePicker, source: sourceType)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    internal func presentImagePicker(controller: UIImagePickerController, source: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = source
        controller.allowsEditing = true
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

extension CreateFileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateFileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == imageList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            if (indexPath.item == 0) {
                cell.frame.origin.x = 5
            }
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
            return cell
        } else {
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
            cell.imageView.image = imageList[indexPath.row]
            return cell
        }
    }
}

extension CreateFileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageList.append(image)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
