//
//  InstructionsView.swift
//  Breeze
//
//  Created by Breeze on 1/13/22.
//
import SwiftUI

struct InstructionsView: View {
    @State private var endViewIsPresenting = false
    var body: some View {
        ZStack {
            VStack (alignment: .center) {
                Spacer()
                Text("When you receive a push notification you can:")
                    .font(.body)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 35)
                Text("•  Accept the notification to play the game, make progress and explorew new islands!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("•  Deny the notification.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.leading)
                    .padding(.trailing)
                Text("•  Press and hold the notification to let us know whether you are doing work or slacking off.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("The more often you accept the notification, \nthe farther your boat will sail!")
                    .font(.body)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 35)
                    .padding(.bottom, 30)
                Button("Next", action: {endViewIsPresenting.toggle()})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                Spacer()
            }
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
