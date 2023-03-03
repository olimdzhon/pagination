//
//  AppDelegate.swift
//  Pagination
//
//  Created by Олимджон Садыков on 02/03/23.
//

import UIKit
import SQLite3

var dbQueue: OpaquePointer!

// Variable to store the location of the SQLite DB.
//var dbURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

let THIS_FILES_PATH:String = #file

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dbQueue = createAndOpenDatabase() // create and open database + set pointer
        
        //        if (createTables() == false) {
        //            print("Error in Creating Tables")
        //        } else {
        //            print("YAY! tables created!")
        //        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func createAndOpenDatabase() -> OpaquePointer? { //Swift type for C Pointers
        var db: OpaquePointer?
        
        let url = NSURL(fileURLWithPath: THIS_FILES_PATH) // Sets up the URL to the database
        
        let dirUrl = url.deletingLastPathComponent
        
        // Name your database here
        if let pathComponent = dirUrl?.appendingPathComponent("test_db.sqlite") {
            let filePath = pathComponent.path
            
            if sqlite3_open(filePath, &db) == SQLITE_OK {
                print("Successfully opened the database :) at \(filePath)")
                
                return db
            } else {
                print("Could not open the database")
            }
        } else {
            print("File path is not available")
        }
        
        return db
    }
    
    //    func createTables() -> Bool {
    //        var bRetVal: Bool = false
    //
    //        let createTable = sqlite3_exec(dbQueue, "CREATE TABLE IF NOT EXISTS tt (_id INTEGER PRIMARY KEY, _name TEXT NULL, _parent_id INTEGER)", nil, nil, nil)
    //
    //        if createTable != SQLITE_OK {
    //            print("Not able to create table")
    //            bRetVal = false
    //        } else {
    //            bRetVal = true
    //        }
    //
    //        return bRetVal
    //    }
    
}

