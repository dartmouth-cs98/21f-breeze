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
  @Environment(\.dismiss) private var dismiss

  var body: some View {
      ZStack {
          Color.white.ignoresSafeArea()
          VStack {
              // let points : Int = UserDefaults.standard.getPoints()
              Text(String(UserDefaults.standard.getPoints()))
              Button("Present FamilyActivityPicker") {
                  print(UserDefaults.standard.getPoints())
                  UserDefaults.standard.setPoints(value: 90)
                  print(UserDefaults.standard.getPoints())
                  isPresented = true
              }
          }
          .sheet(isPresented: $isPresented, onDismiss: dismiss.callAsFunction) {
              FamilyActivityPicker(selection: $model.selectionToDiscourage)
          }.onChange(of: model.selectionToDiscourage) { newSelection in
              model.saveApplications(applications: model.selectionToDiscourage.applications)
          }
      }
  }
    
}



