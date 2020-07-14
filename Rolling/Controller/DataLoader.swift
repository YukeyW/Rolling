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
    
    private func url() ->(URL, URL)? {
        guard let libraryDirectoryUrl = manager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
        let folderUrl = libraryDirectoryUrl.appendingPathComponent("RollingApp", isDirectory: true)
        let fileUrl = folderUrl.appendingPathComponent("music.json")
        return (folderUrl, fileUrl)
    }
    
    private func modelToJason(fileUrl: URL) {
        do {
            let data = try Data(contentsOf: fileUrl)
            let dataFromJson = try JSONDecoder().decode([Model].self, from: data)
            model = dataFromJson
        } catch {
            print(error)
        }
    }
    
    private func jsonToData(fileUrl: URL, newModel: [Model]) {
        do {
            let jsonData = try JSONEncoder().encode(newModel)
            try jsonData.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    private func addImage(imageList:[UIImage], filePath: String) {
        do {
            try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        
        for (index, image) in imageList.enumerated() {
            let imageData = image.pngData()
            let newPath = URL.init(string: "file://" + filePath)?.appendingPathComponent("picture" + "\(index)" + ".png")
            try? imageData?.write(to: newPath!)
        }
    }
    
    func load() {
        let (folderUrl, fileUrl) = url()!
        let exist = manager.fileExists(atPath: folderUrl.path)
        if !exist {
            try! manager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            model = []
        } else {
            modelToJason(fileUrl: fileUrl)
        }
    }
    
    func removeFile(newModel: [Model], index: Int, name:String) {
        let (folderUrl, fileUrl) = url()!
        let filePath = folderUrl.path + "/" + "\(name)"
        if manager.fileExists(atPath: filePath) {
            try! manager.removeItem(atPath: filePath)
        }
        model = newModel
        model.remove(at: index)
        jsonToData(fileUrl: fileUrl, newModel: model)
    }

    func save(model: [Model], imageArray: [UIImage], name: String) {
        self.model = model
        let (folderUrl, fileUrl) = url()!
        print(folderUrl.path)
        let exist = manager.fileExists(atPath: folderUrl.path)
        let path = folderUrl.path + "/" + "\(name)"
        if !exist {
            try! manager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        }
        jsonToData(fileUrl: fileUrl, newModel: model)
        addImage(imageList: imageArray, filePath: path)
    }
    
    func edit(newModel: [Model], imageArray: [UIImage], index: Int) {
        if newModel[index] != model[index] {
            let (folderUrl, fileUrl) = url()!
            let filePath = folderUrl.path + "/" + "\(model[index].name)"
            let path = folderUrl.path + "/" + "\(newModel[index].name)"

            if manager.fileExists(atPath: filePath) {
                try! manager.removeItem(atPath: filePath)
            }
            jsonToData(fileUrl: fileUrl, newModel: newModel)
            addImage(imageList: imageArray, filePath: path)
        }
        self.model = newModel
    }
}

