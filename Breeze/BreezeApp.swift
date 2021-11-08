//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import UserNotifications
import FamilyControls

@available(iOS 15.0, *)

@main
struct BreezeApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var appsToTrackHaveBeenSelected = false
    @StateObject var model = MyModel.shared
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}

@available(iOS 15.0, *)
class AppDelegate: NSObject, UIApplicationDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.requestNotificationAuthorization()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Will fail with an error code of 2 on simulator since not signed into iCloud w/child's account
        AuthorizationCenter.shared.requestAuthorization { result in
                    // The request can either result in success or failure
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        print("Error for Family Controls: \(error)")
                    }
        }
        MySchedule.setSchedule()
        
        return true
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
}
