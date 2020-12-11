//
//  AppDelegate.swift
//  Day4Sample
//
//  Created by 柳田昌弘 on 2020/12/07.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // initialise here
        setupDefaultCache()
        
        return true
    }
    
    private func setupDefaultCache() {
        guard MyPreference.shared.isFirstLaunch else { return }
        
        if let filePath = Bundle.main.path(forResource: "sample-list", ofType: "json"),
            let fileContents = try? String(contentsOfFile: filePath) {
            do {
                let json = try JSON(parseJSON: fileContents)
                if let dataArray = Mapper<Content>().mapArray(JSONObject: json.arrayObject) {
                    let realm = try Realm()
                    // delete all existing objects in advance
                    let oldObjects = realm.objects(Content.self)
                    try realm.write {
                        realm.delete(oldObjects)
                        dataArray.forEach { content in
                            // create new one
                            realm.create(Content.self, value: [content.id, content.name, content.address, content.genderId])
                        }
                    }
                    print("🎉SetupDefaultCache success!!")
                } else {
                    print("⚠️LocalFile mapping error")
                }
            } catch let error {
                print("⚠️Realm error: desc= \(error.localizedDescription)")
            }
        } else {
            print("⚠️Local File read error")
        }
        MyPreference.shared.isFirstLaunch = false
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
}

