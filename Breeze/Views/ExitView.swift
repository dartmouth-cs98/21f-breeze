//
//  ExitView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI

struct ExitView: View {
    
    @Binding var exitViewIsPresenting: Bool
    @State private var quote = UserDefaults.standard.string(forKey: "quote") ?? ""
    @State private var author = UserDefaults.standard.string(forKey: "author") ?? ""
    
    var body: some View {
        ZStack {
            Color.init(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
            VStack {
                Text("Thanks for playing, enjoy your day!")
                    .font(Font.custom("Baloo2-Bold", size:25)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding()
                    .padding()
                Text("\"" + quote + "\"")
                    .font(Font.custom("BethEllen-Regular", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("- " + author)
                    .font(Font.custom("BethEllen-Regular", size:15)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
        }
    }
    
//    func goToTapToPlay () {
//        if (UserDefaults.standard.getDaysFromLastPlay() <= 1) {
//            UserDefaults.standard.setLastDatePlayedToToday()
//        }
//        UserDefaults.standard.synchronize()
//        UserDefaults.standard.set(true, forKey: "hasntFinishedGame")
//        exitViewIsPresenting.toggle()
//    }
}


