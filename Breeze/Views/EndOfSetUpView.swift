//
//  EndOfSetUpScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct EndOfSetUpView: View {
    var body: some View {
        ZStack {
            Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
            VStack (alignment: .center) {
                Text("Thank you for configuring Breeze. We will notify you when you reach your time limit.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("For now, feel free to close the app.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("We can't wait to take a break with you soon!")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Exit Set Up", action: {UserDefaults.standard.set(false, forKey: "hasntExitedEndOfSetUpView")})
                    .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
            }.buttonStyle(.bordered)
        }
    }
}

@available(iOS 15.0, *)
struct EndOfSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        EndOfSetUpView()
    }
}
