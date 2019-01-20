//
//  DataManager.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/20/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var docsDir: URL? {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        } catch {
            print(error)
            return nil
        }
    }
    
    func readFromDisk() -> [Board]{
        let documentDirectory = self.docsDir
        let fileURL = documentDirectory?.appendingPathComponent("data.json")
        
        guard fileURL != nil else {
            return []
        }
        
        var temp: Data? = nil
        do {
            temp = try Data(contentsOf: fileURL!)
        } catch {
            print(error)
        }
        
        let decoder = JSONDecoder()
        if let jsonData = temp  {
            do {
                let oldBoards = try decoder.decode([Board].self, from: jsonData);
                return oldBoards
            } catch {
                print(error)
            }
        }
        return []
    }
    
    func saveToDisk(b: Board){
        
        var boards = self.readFromDisk()
        boards.append(b)
        
        let documentDirectory = self.docsDir
        
        guard let fileURL = documentDirectory?.appendingPathComponent("data.json") else {
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(boards)
            try data.write(to: fileURL)
        } catch let err {
            print(err)
        }
    }
    
    func deleteFromDisk(b: Board){
        
        var boards = self.readFromDisk()
        boards = boards.filter {$0.id != b.id }
        
        let documentDirectory = self.docsDir
        guard let fileURL = documentDirectory?.appendingPathComponent("data.json") else {
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(boards)
            try data.write(to: fileURL)
        } catch let err {
            print(err)
        }
        
    }
}

enum DataNotification{
    
    case boardSaved(b: Board)
    case boardLoaded(b: Board)
    case choiceConfigured(c: Choice)
    
    var notificationName: String{
        switch self {
        case .boardSaved(_):
            return "boardSaved"
        case .boardLoaded(_):
            return "boardLoaded"
        case .choiceConfigured(_):
            return "choiceConfigured"
        }
    }
    
    func notify() {
        var info: [AnyHashable: Any] = [:]
        switch self {
        case .boardSaved(let b):
            info["board"] = b
        case .boardLoaded(let b):
            info["board"] = b
        case .choiceConfigured(let c):
            info["choice"] = c
        }
        NotificationCenter.default.post(name: Notification.Name(self.notificationName), object: nil, userInfo: info)
    }
}
