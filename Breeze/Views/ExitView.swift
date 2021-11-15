//
//  ExitView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI

struct ExitView: View {
    var body: some View {
        VStack {
            Text("Thanks for playing, enjoy your day!")
                .font(Font.custom("Baloo2-Bold", size:20))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct ExitView_Previews: PreviewProvider {
    static var previews: some View {
        ExitView()
    }
}
