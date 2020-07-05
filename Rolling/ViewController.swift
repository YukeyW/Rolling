//
//  ViewController.swift
//  Rolling
//
//  Created by yukey on 14/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var model: Model?
    let dataLoader = DataLoader()
    lazy var newModel = dataLoader.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination  = segue.destination as? CreateFileViewController {
            destination.imageDelegate = self
            if model != nil {
                destination.model = self.model
                destination.imageList = convertImage()
                destination.eventState = EventState.existingEvent
            } else {
                destination.eventState = EventState.addEvent
            }
        }
    }
    
    func convertDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    @objc func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let point = longPressGR.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let cell = self.collectionView.cellForItem(at: indexPath)
            actionSheet.addAction(UIAlertAction(title: "delete", style: .default, handler: { _ in
                self.deleteDocument(indexPath: indexPath)}))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.popoverPresentationController?.sourceView = cell;
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: cell?.bounds.midX ?? 0, y: cell?.bounds.midY ?? 0, width: 0, height: 0)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }

    func deleteDocument(indexPath: IndexPath) {
        dataLoader.removeFile(newModel: newModel, index: (indexPath.row - 1), name: newModel[indexPath.row - 1].name)
        newModel.remove(at: indexPath.row - 1)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func convertImage() -> [UIImage] {
        var image = [UIImage]()
        if let imageDataList = model?.image {
            for imageData in imageDataList {
                image.append(imageData.getImage()!)
            }
        }
        return image
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newModel.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addDocumentCell", for: indexPath)
            if (indexPath.item == 0) {
                cell.frame.origin.x = 5
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as! DocumentCollectionViewCell
            cell.documentName.text = newModel[indexPath.row - 1].name
            cell.date.text = newModel[indexPath.row - 1].date
            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
            cell.addGestureRecognizer(longPressGR)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.model = newModel[indexPath.row - 1]
        } else {
            self.model = nil
        }
        performSegue(withIdentifier: "viewController", sender: self)
    }
}

extension ViewController: CreateFileViewControllerDelegate {
    func saveToModel(textName: String, imageList: [UIImage]) {
        var newImageList = [Image]()
        for image in imageList {
            newImageList.append(Image(withImage: image))
        }
        self.model = Model(name: textName, image: newImageList, date: convertDateToString())
        newModel.append(self.model!)
        dataLoader.save(model: newModel, imageArray: imageList)
    }
    
    func editModel(textName: String, imageList: [UIImage]) {
        var num = 0
        var newImageList = [Image]()
        for (index, doc) in newModel.enumerated() {
            if doc == model {
                num = index
            }
        }
        for image in imageList {
            newImageList.append(Image(withImage: image))
        }
        self.model = Model(name: textName, image: newImageList, date: convertDateToString())
        newModel[num] = self.model!
        dataLoader.edit(newModel: newModel, imageArray: imageList, index: num)
    }
    
    func checkName(name: String?) -> Bool {
        for document in newModel {
            if document == model {
                continue
            } else if document.name == name {
                return false
            }
        }
        return true
    }
}
