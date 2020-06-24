//
//  Data loader.swift
//  Rolling
//
//  Created by yukey on 24/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import Foundation
import UIKit

public class DataLoader {
    var model = [Model]()
    
//    init() {
//        load()
//    }
//
//    func load() {
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//
//        do {
//            let fileUrls = try FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil)
//            let data = try Data(contentsOf: fileUrls[0])
//            let jsonDecoder = JSONDecoder()
//            let dataFromJson = try jsonDecoder.decode([Model].self, from: data)
//            self.model = dataFromJson
//            } catch {
//                print(error)
//        }
//    }
    
    func save(model: [Model]) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let path = documentDirectoryUrl.path + "/music"
        let url = URL.init(string: "file://" + path)!
        let fileUrl = url.appendingPathComponent("Persons.json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: model, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
        
        for arrayItem in model {
            let newPath = url.path + "/" + "\(arrayItem.name)"
            
            for image in arrayItem.image {
                let imageData = image.pngData()
                try? imageData?.write(to: URL(fileURLWithPath: newPath))
            }
        }
    }
}
