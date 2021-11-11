//
//  FamilyActivityPickerView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/21/21.
//

import Foundation
import SwiftUI
import FamilyControls

@available(iOS 15.0, *)
struct FamilyActivityPickerView: View {
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    @State var appsToTrackHaveBeenSelected = false
    @EnvironmentObject var model: MyModel
    // @State var deviceMonitor: deviceActivityMonitorForTrackingScreenTime = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // first screen before the user selects which apps to track
        if (!appsToTrackHaveBeenSelected) {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Text("Welcome to Breeze.")
                        .font(Font.custom("Baloo2-Regular", size:20))
                        .padding()
                    Text("To begin, please select which apps you would like to monitor.")
                        .font(Font.custom("Baloo2-Regular", size:20))
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Select Apps", action: setIsPresentedTrue)
                        .font(Font.custom("Baloo2-Regular", size:20))
                        .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                        .foregroundColor(Color.black)
                        .padding()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $isPresented, onDismiss: didDismiss) {
                    FamilyActivityPicker(selection: $selection)
                }.onChange(of: selection) { newSelection in
                     model.selectionToDiscourage = newSelection
                     model.saveSelection()
                     MySchedule.setSchedule()
                }
            }
        }
        
        // second screen after the user selects which apps to track
        else {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Text("Welcome to Breeze.")
                        .font(Font.custom("Baloo2-Regular", size:20))
                        .padding()
                    Text("Continue set up by setting a time limit, after which Breeze will notify you when you use your selected apps.")
                        .font(Font.custom("Baloo2-Regular", size:20))
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Set time limit", action: {UserDefaults.standard.set(false, forKey: "didLaunchBefore")})
                        .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                        .foregroundColor(Color.black)
                        .padding()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    func setIsPresentedTrue() {
        isPresented = true
    }
    
    func didDismiss() {
        print("func called")
        appsToTrackHaveBeenSelected = true
        //dismiss()
    }
}



