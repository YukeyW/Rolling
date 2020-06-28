//
//  Data loader.swift
//  Rolling
//
//  Created by yukey on 24/6/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import Foundation
import UIKit

class DataLoader {
    var model = [Model]()
    
    init() {
        self.load()
    }
    
    func load() {
        let manager = FileManager.default
        guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let folder = libraryDirectoryUrl.appendingPathComponent("/RollingApp", isDirectory: true)
        let exist = manager.fileExists(atPath: folder.path)
        if !exist {
            try! manager.createDirectory(at: folder, withIntermediateDirectories: true,
                                         attributes: nil)
            model = []
        } else {
            do {
                let path = folder.path + "/music.json"
                let newUrl = URL.init(string: "file://" + path)!
                let data = try Data(contentsOf: newUrl)
                let dataFromJson = try JSONDecoder().decode([Model].self, from: data)
                model = dataFromJson
                print("\(model)")
            } catch {
                print(error)
            }
        }
    }

    func save(model: [Model], imageArray: [UIImage]) {
        let manager = FileManager.default
        guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let folder = libraryDirectoryUrl.appendingPathComponent("/RollingApp", isDirectory: true)
        let exist = manager.fileExists(atPath: folder.path)
        if !exist {
            try! manager.createDirectory(at: folder, withIntermediateDirectories: true,
                                         attributes: nil)
        }
        let fileUrl = folder.appendingPathComponent("music.json")
        print("\(fileUrl)")
        do {
            let jsonData = try JSONEncoder().encode(model)
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }

        for arrayItem in model {
            let path = folder.path + "/" + "\(arrayItem.name)"
            do{
                try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }

            for (index, image) in imageArray.enumerated() {
                let imageData = image.pngData()
                let newPath = URL.init(string: "file://" + path)?.appendingPathComponent("picture" + "\(index)" + ".png")
                try? imageData?.write(to: newPath!)
            }
        }
    }
}
