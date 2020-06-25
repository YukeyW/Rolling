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
//    var model = [Model]()
    
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
//    
//    func json(from object:Any) -> String? {
//        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
//            return nil
//        }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
    
    func save(model: [Model], imageArray: [UIImage]) {
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("music.json")
        print("\(fileUrl)")
        do {
            let jsonData = try JSONEncoder().encode(model)
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }

        for arrayItem in model {
            let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let DirPath = DocumentDirectory.appendingPathComponent("\(arrayItem.name)")
            do{
                try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
            print("\(String(describing: DirPath))")

            for (index, image) in imageArray.enumerated() {
                let imageData = image.pngData()
                let newPath = DirPath?.appendingPathComponent("picture" + "\(index)" + ".png")
                try? imageData?.write(to: newPath!)
            }
        }
    }
}
