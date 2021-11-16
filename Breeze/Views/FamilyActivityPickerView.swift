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
    @State var familyActivityPickerIsPresenting = false
    @AppStorage("appsToTrackHaveBeenSelected") var appsToTrackHaveBeenSelected: Bool = false
    //@State private var timeSelectionIsPresenting = false
    
    @EnvironmentObject var model: MyModel
    // @State var deviceMonitor: deviceActivityMonitorForTrackingScreenTime = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // first screen before the user selects which apps to track
        if (!appsToTrackHaveBeenSelected) {
            ZStack {
                Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
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
                        .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
                        .foregroundColor(Color.black)
                        .cornerRadius(6)
                        .padding()
                }.buttonStyle(.bordered)
                .sheet(isPresented: $familyActivityPickerIsPresenting, onDismiss: didDismissFamilyActivityPickerView) {
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
            Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
            TimeLimitInstructionsView()
        }
    }
    
    func setIsPresentedTrue() {
        familyActivityPickerIsPresenting = true
    }
    
    func didDismissFamilyActivityPickerView() {
        appsToTrackHaveBeenSelected = true
    }
    
    func didDismissTimeSelectionView() {
        UserDefaults.standard.set(false, forKey: "hasntFinishedSetup")
    }
}



