//
//  ContentView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import CoreData
import SpriteKit


@available(iOS 15.0, *)
struct ContentView: View {
    
    @State var tapToPlayView = TapToPlayView()
    @State private var showModal = false
    @State var profileView = ProfileView()
    
    func viewDidLoad() {
        
    }
    @ViewBuilder
    var body: some View {
        ZStack {
            Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
            profileView
            //tapToPlayView
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
