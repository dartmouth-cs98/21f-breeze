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
    @State private var startTime = Time(hours:0, minutes:0, seconds:0)

    var body: some View {
        ZStack {
           VStack {
             Text("Breeze will notify you every...")
                   .font(Font.custom("Baloo2-Regular", size:20))
                   .multilineTextAlignment(.center)
             DurationPickerView(time: $startTime)
             Button("Confirm", action: selectTime)
                .font(Font.custom("Baloo2-Regular", size:20))
                .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                .foregroundColor(Color.black)
                .cornerRadius(6)
                .padding()
           }.buttonStyle(.bordered)
        }
    }
    
    func selectTime() {
        print("Time selected")
        let timeInMinutes = startTime.hours*60 + startTime.minutes
        UserDefaults.standard.setTime(value: timeInMinutes)
        UserDefaults.standard.setSetupBool(value: true)
        timeSelectionIsPresenting.toggle()
    }
    
 }
