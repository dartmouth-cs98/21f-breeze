//
//  TimeSelectionView.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/9/21.
//
import Foundation
import SwiftUI
struct LocationAuthorizationView: View {
    
    // @Binding var locationAuthorizationIsPresenting: Bool
    @State private var locationSelected = false;

    var body: some View {
        ZStack {
           VStack {
               Text("One more thing: ")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.bottom, 5)
                   .foregroundColor(Color.black)
               Text("In order to track your screen time, Breeze needs to use location updates to keep running in the background")
                   .font(.body)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 50)
                   .lineSpacing(5)
                   .foregroundColor(Color.black)
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
        
    }
    
 }

struct LocationAuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAuthorizationView()
    }
}
