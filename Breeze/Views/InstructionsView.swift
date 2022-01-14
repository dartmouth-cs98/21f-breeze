//
//  InstructionsView.swift
//  Breeze
//
//  Created by Breeze on 1/13/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct InstructionsView: View {
    @State private var endViewIsPresenting = false
    var body: some View {
        ZStack {
            VStack (alignment: .center) {
                Spacer()
                Text("When you receive a push notification you can:")
                    .font(Font.custom("Baloo2-Bold", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("•  Accept the notification to play the game, make progress and explorew new islands!")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("•  Deny the notification.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("•  Press and hold the notification to let us know whether you are doing work or slacking off.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 50)
                Text("The more often you accept the notification, the farther your boat will sail!")
                    .font(Font.custom("Baloo2-Bold", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Next", action: {endViewIsPresenting.toggle()})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
                Spacer()
            }.buttonStyle(.bordered)
        }.fullScreenCover(isPresented: $endViewIsPresenting) {
            EndOfSetUpView(endViewIsPresenting: self.$endViewIsPresenting)
            
        }
    }
}


@available(iOS 15.0, *)
struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
