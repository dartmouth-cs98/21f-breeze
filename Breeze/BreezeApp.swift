//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import OneSignal
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAuthCore
import AWSAPIPlugin
import AWSDataStorePlugin

func configureAmplify() {
    let models = AmplifyModels()
    let apiPlugin = AWSAPIPlugin(modelRegistration: models)
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
    do {
        try Amplify.add(plugin: apiPlugin)
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        assert(false, "Could not initialize Amplify: \(error)")
    }
}

func configureOneSignal() {
    
}


@available(iOS 15.0, *)
@main
struct BreezeApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var appsToTrackHaveBeenSelected = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
    
    public init() {
        configureAmplify()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
          
        // OneSignal initialization
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("371443da-249d-4c97-9f96-2947aaf7a8eb")
          
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
          
        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
        return true
    }
}
