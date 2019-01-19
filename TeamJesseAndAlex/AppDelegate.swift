//
//  AppDelegate.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/18/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager = DataManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



class DataManager {
   
    func writeToDisk(b: Board){
        
        let fileManager = FileManager.default
        var temp: Data? = nil
        var fileURL: URL? = nil
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            fileURL = documentDirectory.appendingPathComponent("data.json")
            guard fileURL != nil else {
                return;
            }
            temp = try Data(contentsOf: fileURL!)
        } catch let err{
            print(err)
        }
        
        var newBoards: [Board] = []
        let decoder = JSONDecoder()
        if let jsonData = temp  {
            do {
                let oldBoards = try decoder.decode([Board].self, from: jsonData);
                for b in oldBoards {
                    newBoards.append(b)
                }
            } catch let err {
                print(err)
            }
        }
        
        newBoards.append(b)
        
        let encoder = JSONEncoder()
        do {
            let dataToWrite = try encoder.encode(newBoards)
            try dataToWrite.write(to: fileURL!)
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

struct Board: Codable {
    var name: String?
    var id: UUID
    var choices: [Choice]
    var numberOfChoices: Int {
        return choices.count
    }
    init(name: String, choices: [Choice]) {
        self.id = UUID()
        self.choices = choices
        self.name = name
    }
    init() {
        self.id = UUID()
        choices = []
    }
}

struct Choice: Codable{
    var id: UUID
    var name: String?
    var imagePath: URL?
    var audioRecordingPath: URL?
    
    init() {
        self.id = UUID()
    }
}
