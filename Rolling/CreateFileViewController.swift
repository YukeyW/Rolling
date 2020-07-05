//
//  CreateFileViewController.swift
//  Rolling
//
//  Created by yukey on 14/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

protocol CreateFileViewControllerDelegate: class {
    func saveToModel(textName: String, imageList: [UIImage])
    func editModel(textName: String, imageList: [UIImage])
    func checkName(name: String?) -> Bool
}

enum EventState {
  case addEvent
  case existingEvent
}

class CreateFileViewController: UIViewController {
    var imageList = [UIImage]()
    var model: Model?
    var eventState: EventState?
    
    weak var imageDelegate: CreateFileViewControllerDelegate?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.layer.borderColor = UIColor.opaqueSeparator.cgColor
            imageCollectionView.layer.borderWidth = 1
        }
    }
    
    @objc func tapEdit() {
        UIView.animate(withDuration: 0.3, animations: {
            self.textFieldHeightConstraint.constant = 40
            self.textField.text = self.title
            self.view.layoutIfNeeded()
        }) { _ in
            self.isShowed(hide: false)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSave))
    }
    
    @objc func tapSave() {
        if checkDocument() {
            self.title = textField.text
            
            UIView.animate(withDuration: 0.3, animations: {
                self.textFieldHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.isShowed(hide: true)
                self.textField.resignFirstResponder()
            }

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit))
            if eventState == EventState.existingEvent {
                imageDelegate?.editModel(textName: textField.text!, imageList: imageList)
            } else {
                imageDelegate?.saveToModel(textName: textField.text!, imageList: imageList)
                eventState = EventState.existingEvent
            }
        }
    }
    
    func checkDocument() -> Bool {
        if textField.text == "" {
            addAlert(content: "You should input document name")
            return false
        } else if !(imageDelegate?.checkName(name: textField.text))!{
            addAlert(content: "Name has already existed")
            return false
        } else {
            return true
        }
    }

    @IBAction func tapAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cell = imageCollectionView.cellForItem(at: [0,imageList.count])

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(imagePicker: imagePickerController, sourceType: .camera) }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(controller: imagePickerController, source: .photoLibrary) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = cell;
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell?.bounds.midX ?? 0, y: cell?.bounds.midY ?? 0, width: 0, height: 0)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isShowed(hide: Bool) {
        label.isHidden = hide
        button.isHidden = !hide
        imageCollectionView.cellForItem(at: [0, imageList.count])?.isHidden = hide
        for (index, _) in imageList.enumerated() {
            if let cell = imageCollectionView.cellForItem(at: [0, index]) as? ImageCollectionViewCell {
                cell.button.isHidden = hide
            }
        }
    }

    func openCamera(imagePicker: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        if(UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            presentImagePicker(controller: imagePicker, source: sourceType)
        } else {
            addAlert(content: "You don't have camera")
        }
    }
    
    func addAlert(content: String) {
        let alert  = UIAlertController(title: "Warning", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func presentImagePicker(controller: UIImagePickerController, source: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = source
        controller.allowsEditing = true
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.clearButtonMode = .whileEditing
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        updateUI()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ScrollPageViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScrollPageViewController {
            destination.newImageList = self.imageList
            destination.name = self.title
        }
    }
    
    private func updateUI() {
        if model != nil {
            textFieldHeightConstraint.constant = 0
            self.title = model?.name
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit))
        } else {
            button.isHidden = true
        }
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
            if eventState == EventState.existingEvent && textFieldHeightConstraint.constant == 0 {
                cell.isHidden = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
            cell.imageView.image = imageList[indexPath.row]
            cell.delegate = self
            if eventState == EventState.existingEvent && textFieldHeightConstraint.constant == 0 {
                cell.button.isHidden = true
            }
            return cell
        }
    }
}

extension CreateFileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageList.append(image)
            let insertIndexPath = IndexPath(item: imageList.count-1, section: 0)
            imageCollectionView.insertItems(at: [insertIndexPath])
            if navigationItem.rightBarButtonItem == nil && imageList.count != 0 {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSave))
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateFileViewController: ImageCellDelegate {
    func delete(cell: ImageCollectionViewCell) {
        if let indexPath = imageCollectionView?.indexPath(for: cell) {
            imageList.remove(at: indexPath.item)
            imageCollectionView?.deleteItems(at: [indexPath])
            if imageList.count == 0 {
                navigationItem.rightBarButtonItem = nil
                let cell = imageCollectionView.cellForItem(at: [0,0])
                cell?.frame.origin.x = 5
            }
        }
    }
}
