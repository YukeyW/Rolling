//
//  Model.swift
//  Rolling
//
//  Created by yukey on 23/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import Foundation
import UIKit

struct Model {
    let name: String
    let image: [UIImage]
    let date: Date
    
    init(name: String, image: [UIImage], date: Date) {
        self.name = name
        self.image = image
        self.date = date
    }
}

