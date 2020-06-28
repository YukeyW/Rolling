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
    
    let dataLoader = DataLoader()
    lazy var newModel = dataLoader.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupNavBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFile" {
            if let cfc = segue.destination as? CreateFileViewController {
                cfc.imageDelegate = self
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
            return cell
        }
    }
}

extension ViewController: CreateFileViewControllerDelegate {
    func saveToModel(textName: String, imageList: [UIImage]) {
        var newImageList = [Image] ()
        for image in imageList {
            newImageList.append(Image(withImage: image))
        }
        newModel.append(Model(name: textName, image: newImageList, date: convertDateToString()))
        dataLoader.save(model: newModel, imageArray: imageList)
    }
}
