//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

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


@available(iOS 15.0, *)
@main
struct BreezeApp: App {
    let persistenceController = PersistenceController.shared
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
