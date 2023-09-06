//
//  PRTYApp.swift
//  PRTY
//
//  Created by Quinn Butcher on 11/5/22.
//


import SwiftUI
import Foundation
import FirebaseCore
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}




@main
struct PRTYApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    
    let app = App(id: "application-prty-vtmer")
//
//    func loginToRealmAnonymous() {
//            app.login(credentials: Credentials.anonymous) { (error) in
//                print("Anonymous login to realm")
//                DispatchQueue.main.sync {
//                    print("Realm login message: \(error)")
//                    let user = self.app.currentUser
//                    user?.logOut() { (error) in
//                        DispatchQueue.main.sync {
//                            print("Realm user logged out");
//                        }
//                    }
//                }
//            }
//        }
//    init() {
//        loginToRealmAnonymous()
//    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
        }
    }
}

