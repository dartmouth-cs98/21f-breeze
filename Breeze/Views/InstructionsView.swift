//
//  InstructionsView.swift
//  Breeze
//
//  Created by Breeze on 1/13/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct InstructionsView: View {
    var body: some View {
        ZStack {
            Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
            VStack (alignment: .center) {
                Text("temp")
            }
        }
    }
}


@available(iOS 15.0, *)
struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
