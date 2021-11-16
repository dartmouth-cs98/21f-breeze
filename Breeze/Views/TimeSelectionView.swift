//
//  TimeSelectionView.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/9/21.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
struct TimeSelectionView: View {
    @Binding var timeSelectionIsPresenting: Bool
    var frameworks = ["15 minutes", "30 minutes", "45 minutes", "1 hour", "1 hour 15 minutes", "1 hour 30 minutes"]
    @State private var selectedIndex:Int = 0

    var body: some View {
        ZStack {
           Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
           VStack {
             Text("Breeze will interrupt you on you selected apps after:")
                   .font(Font.custom("Baloo2-Regular", size:20))
                   .multilineTextAlignment(.center)
             Picker(selection: $selectedIndex, label: Text("Select an interval")) {
                 ForEach(0 ..< frameworks.count) {
                    Text(self.frameworks[$0]).font(Font.custom("Baloo2-Regular", size:20))
                 }
             }
             Button("Confirm", action: selectTime)
                .font(Font.custom("Baloo2-Regular", size:20))
                .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
                .foregroundColor(Color.black)
                .cornerRadius(6)
                .padding()
           }.buttonStyle(.bordered)
                //.edgesIgnoringSafeArea(.all)
        
        }
    }
    
    func selectTime() {
        print("Time selected")
        let minutes = (selectedIndex + 1) * 15
        UserDefaults.standard.setTime(value: minutes)
        UserDefaults.standard.setSetupBool(value: true)
        timeSelectionIsPresenting.toggle()
    }
    
 }

/*
@available(iOS 15.0, *)
struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView()
    }
}
*/
