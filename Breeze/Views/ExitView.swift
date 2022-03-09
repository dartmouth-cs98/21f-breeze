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
                    .font(.title2).bold().foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding()
                    .padding()
                Text("\"" + quote + "\"")
                    .font(.body).italic().foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("- " + author)
                    .font(.body).italic().foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Take me home!", action: {goToTapToPlay()})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
            }
        }
    }
    
    func goToTapToPlay () {
        exitViewIsPresenting.toggle()
    }
}


