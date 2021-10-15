//
//  SplashScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/15/21.
//

import Foundation
import SwiftUI

struct LaunchView: View {

    @State var isActive:Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                ContentView()
            } else {
                Image("BreezeLogo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }.onDisappear {
            self.isActive = false
        }
    }
    
}
