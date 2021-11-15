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
            Color.white.ignoresSafeArea()
            VStack (alignment: .center) {
                Text("Thank you for configuring Breeze. We will notify you when you reach your time limit on apps you asked us to monitor.")
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
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
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
