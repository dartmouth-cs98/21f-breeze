//
//  FamilyActivityPickerView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/21/21.
//

import Foundation
import SwiftUI
import FamilyControls
import RealmSwift

@available(iOS 15.0, *)
struct FamilyActivityPickerView: View {
  @State var selection = FamilyActivitySelection()
  @State var isPresented = false
  @State var appsToTrackHaveBeenSelected = false
  // @State var deviceMonitor: deviceActivityMonitorForTrackingScreenTime = nil
  @EnvironmentObject var store: DeviceStore
  @Environment(\.presentationMode) var presentationMode
  //@ObservedObject var form: DeviceForm
  @Environment(\.dismiss) private var dismiss
    
  var body: some View {
      ZStack {
          Color.white.ignoresSafeArea()
          VStack {
              Button("Present FamilyActivityPicker") {
                  isPresented = true
              }
          }
          .sheet(isPresented: $isPresented, onDismiss: dismiss.callAsFunction) {
              FamilyActivityPicker(selection: $selection)
          }.onChange(of: selection) { newSelection in
              // let blocked: [String] = ["Eggs", "Milk"]
              // manually add list items
              store.create(timeInMinutes: 15)
            
              let applications = selection.applications
              let categories = selection.categories
              let webDomains = selection.webDomains
              var deviceMonitor = deviceActivityMonitorForTrackingScreenTime(applications: applications, categories: categories, webDomains: webDomains)
          }
          
      }
      
  }
    
}



