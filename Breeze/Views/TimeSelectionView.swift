//
//  TimeSelectionView.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/9/21.
//

import Foundation
import SwiftUI

struct TimeSelectionView: View {
    var frameworks = ["15 minutes", "30 minutes", "45 minutes", "1 hour", "1 hour 15 minutes", "1 hour 30 minutes"]
    @State private var selectedIndex:Int = 0

    var body: some View {
       VStack {
         Text("Breeze will interrupt you on you selected apps after:")
         Picker(selection: $selectedIndex, label: Text("")) {
             ForEach(0 ..< frameworks.count) {
                Text(self.frameworks[$0])
             }
         }
         Button(action: selectTime) {
             Text("Confirm")
            .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
            .foregroundColor(Color.black)
            .padding()
         }.padding()
       }
    }
    
    func selectTime() {
        print("Time selcted")
        let minutes = (selectedIndex + 1) * 15
        UserDefaults.standard.setPoints(value: minutes)
    }
 }
