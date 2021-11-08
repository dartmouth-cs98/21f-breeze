//
//  FamilyActivityPickerView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/21/21.
//

import Foundation
import SwiftUI
import FamilyControls

//  NOTE: this is a func I used to print out every font name we have access to, but for some reason Baloo wasn't showing up in it, even though I believe it should be bc I added it to info.plist. I am probably definitely just overlooking some stupid error.
//    init() {
//        self.printAllFonts()
//    }
//
//    func printAllFonts() {
//        for family: String in UIFont.familyNames
//        {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
//    }

@available(iOS 15.0, *)
struct FamilyActivityPickerView: View {
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    @State var appsToTrackHaveBeenSelected = false
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
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Select Apps", action: setIsPresentedTrue)
                        .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                        .foregroundColor(Color.black)
                        .padding()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $isPresented, onDismiss: didDismiss) {
                    FamilyActivityPicker(selection: $selection)
                }.onChange(of: selection) { newSelection in
                    let applications = selection.applications
                    let categories = selection.categories
                    let webDomains = selection.webDomains
                    var deviceMonitor = deviceActivityMonitorForTrackingScreenTime(applications: applications, categories: categories, webDomains: webDomains)
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
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Set time limit", action: setIsPresentedTrue)
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
        dismiss()
    }
}



