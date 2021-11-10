//
//  TapToPlayScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI

struct TapToPlayView: View {
    var body: some View {
        Color.white.ignoresSafeArea()
        VStack {
            // attribution to Alfredo Hernandez for the icon
            Image("right-arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 75)
            Text("Tap to Play")
                .font(Font.custom("Baloo2-Regular", size:20))
                .padding()
        }
    }
}

struct TapToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        TapToPlayView()
    }
}
