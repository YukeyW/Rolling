//
//  imageCollectionViewCell.swift
//  Rolling
//
//  Created by yukey on 19/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: class {
    func delete(cell: ImageCollectionViewCell)
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: ImageCellDelegate?
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}
