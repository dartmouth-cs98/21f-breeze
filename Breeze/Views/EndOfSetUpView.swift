import Foundation
import SwiftUI

struct EndOfSetUpView: View {
    @Binding var endViewIsPresenting: Bool
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack (alignment: .center) {
                Text("Thank you for configuring Breeze. We will notify you when you reach your time limit.")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("For now, feel free to close the app.")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("We can't wait to take a break with you soon!")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Exit Set Up", action: {UserDefaults.standard.set(false, forKey: "hasntExitedEndOfSetUpView")})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
            }
        }
    }
}
