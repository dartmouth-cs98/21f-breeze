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
       Color.white.ignoresSafeArea()
       VStack {
        
         Text("Breeze will interrupt you on you selected apps after:")
               //.multilineTextAlignment(.center)
               .font(Font.custom("Baloo2-Regular", size:20))
         Picker(selection: $selectedIndex, label: Text("Select an interval")) {
             ForEach(0 ..< frameworks.count) {
                Text(self.frameworks[$0]).font(Font.custom("Baloo2-Regular", size:20))
             }
         }
         Button(action: selectTime) {
             Text("Confirm").font(Font.custom("Baloo2-Regular", size:20))
            .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
            .foregroundColor(Color.black)
            
         }.buttonStyle(.bordered)
        Spacer()
       }.edgesIgnoringSafeArea(.all)
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
