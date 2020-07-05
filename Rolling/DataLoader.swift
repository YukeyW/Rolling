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
    let manager = FileManager.default
    
    init() {
        self.load()
    }
    
    func load() {
        guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let folder = libraryDirectoryUrl.appendingPathComponent("RollingApp", isDirectory: true)
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
                print(path)
                print("\(model)")
            } catch {
                print(error)
            }
        }
    }
    
    func removeFile(newModel: [Model], index: Int, name:String) {
        guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        let filePath = libraryDirectoryUrl.path + "/RollingApp" + "/" + "\(name)"
        print(filePath)
        if manager.fileExists(atPath: filePath) {
            try! manager.removeItem(atPath: filePath)
        }
        let fileUrl = URL.init(string: "file://" + libraryDirectoryUrl.path + "/RollingApp/music.json" )!
        model = newModel
        model.remove(at: index)
        do {
            let jsonData = try JSONEncoder().encode(model)
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }

    func save(model: [Model], imageArray: [UIImage]) {
        self.model = model
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
    
    func edit(newModel: [Model], imageArray: [UIImage], index: Int) {
        if newModel[index] != model[index] {
            guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
            let filePath = libraryDirectoryUrl.path + "/RollingApp" + "/" + "\(model[index].name)"
            print(filePath)
            if manager.fileExists(atPath: filePath) {
                try! manager.removeItem(atPath: filePath)
            }
            let fileUrl = URL.init(string: "file://" + libraryDirectoryUrl.path + "/RollingApp/music.json" )!
            do {
                let jsonData = try JSONEncoder().encode(newModel)
                try jsonData.write(to: fileUrl, options: [])
            } catch {
                print(error)
            }
        
            let path = libraryDirectoryUrl.appendingPathComponent("/RollingApp", isDirectory: true).path + "/" + "\(newModel[index].name)"
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
        self.model = newModel
    }
}
