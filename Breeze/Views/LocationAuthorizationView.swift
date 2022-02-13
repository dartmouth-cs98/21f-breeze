//
//  LocationAuthorizationView.swift
//  Breeze
//
//  Created by Sabrina Jain on 2/12/22
//
import Foundation
import SwiftUI
struct LocationAuthorizationView: View {
    
    // @Binding var locationAuthorizationIsPresenting: Bool
    @State private var locationSelected = false;
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some View {
        ZStack {
           VStack {
               Text("One more thing: ")
                   .font(.body).bold()
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 10)
               Text("In order to track your screen time, Breeze needs to use location updates to keep running in the background")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 50).padding(.bottom, 20)
                   .lineSpacing(5)
               Divider()
               Text("After hitting  **`OK`**  you will be prompted,\n please select: \n`Allow While Using App`")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 40)
                   .padding(.top, 20)
                   .padding(.bottom, 10)
                   .lineSpacing(5)
               Divider().padding(.horizontal, 120)
               Text("You will also be prompted again \n**AFTER**  you close Breeze,\nplease select:\n`Change to Always Allow`")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 60)
                   .padding(.bottom, 20)
                   .padding(.top, 10)
                   .lineSpacing(5)
               Divider()
               Text("**Breeze WILL NOT work correctly if you don't follow these instructions!**")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 30).padding(.bottom, 20).padding(.top, 25)
                   .lineSpacing(5)
               Button("OK", action: authorizeLocationUpdates)
                   .padding()
                   .font(.body)
                   .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                   .foregroundColor(Color.black)
                   .cornerRadius(10)
               
           }
        }
    }
    
    func authorizeLocationUpdates() {
        UserDefaults.standard.set(false, forKey: "hasntBeenPromptedForLocationAuthorization")
        appDelegate.locationManager.requestAlwaysAuthorization()
    }
 }

struct LocationAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAuthorizationView()
    }
}
