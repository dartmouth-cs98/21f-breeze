//
//  ContentView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import CoreData
import SpriteKit

let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @State private var showModal = false
    @State private var profileViewIsPresenting = false

    func viewDidLoad() {

    }
    @ViewBuilder
    var body: some View {
        ZStack {
            Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
            if profileViewIsPresenting {
                ProfileView(isPresenting: $profileViewIsPresenting)
            }
            else {
                TapToPlayView(profileViewIsPresenting: $profileViewIsPresenting)
            }
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

