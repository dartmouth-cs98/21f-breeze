//
//  TimeSelectionView.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/9/21.
//
import Foundation
import SwiftUI
struct TimeSelectionView: View {
    @Binding var timeSelectionIsPresenting: Bool
    @State private var startTime = Time(hours:0, minutes:0, seconds:0)
    @State private var timeSelected = false;

    var body: some View {
        ZStack {
           VStack {
               Text("Breeze will notify you every...")
                   .font(.body)
                   .multilineTextAlignment(.center)
               DurationPickerView(time: $startTime, changeTriggered: $timeSelected)
               // if user has touched the durationPicker twice (work around to apple's bug)
               if (timeSelected) {
                   Button("Confirm", action: selectTime)
                       .padding()
                       .font(.body)
                       .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                       .foregroundColor(Color.black)
                       .cornerRadius(6)
               }
               // otherwise, unclickable button
               else {
                   Button("Confirm", action: {})
                       .padding()
                       .font(.body)
                       .background(Color.init(UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)))
                       .foregroundColor(Color.black)
                       .cornerRadius(6)
               }
           }
        }
    }
    
    func selectTime() {
        let timeInMinutes = startTime.hours*60 + startTime.minutes
        UserDefaults.standard.setTime(value: timeInMinutes)
        UserDefaults.standard.setSetupBool(value: true)
        timeSelectionIsPresenting.toggle()
    }
    
 }
