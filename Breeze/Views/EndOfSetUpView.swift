import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct EndOfSetUpView: View {
    @Binding var endViewIsPresenting: Bool
    var body: some View {
        ZStack {
            VStack (alignment: .center) {
                Text("Thank you for configuring Breeze. We will notify you when you reach your time limit.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("For now, feel free to close the app.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("We can't wait to take a break with you soon!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Exit Set Up", action: {UserDefaults.standard.set(false, forKey: "hasntExitedEndOfSetUpView")})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
            }.buttonStyle(.bordered)
        }
    }
}

//@available(iOS 15.0, *)
//struct EndOfSetUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        EndOfSetUpView()
//    }
//}
