//
//  TimeSelectionView.swift
//  Breeze
//
//  Created by Katherine Taylor on 3/6/22.
//
import Foundation
import SwiftUI

struct DifficultySelectionView: View {
    @Binding var difficultySelectionIsPresenting: Bool
    var difficulties = ["1", "2", "3", "4"]
    @State private var oldDifficultyIndex = UserDefaults.standard.getDifficulty() - 1;

    var body: some View {
       VStack {
         Text("Your level of difficulty in the game is:")
               .font(.headline).foregroundColor(Color.black)
         Picker(selection: $oldDifficultyIndex, label: Text("")) {
             ForEach(0 ..< difficulties.count) {
                 Text(self.difficulties[$0]).font(.body).foregroundColor(Color.black)
             }
         }.padding()
        Button("Confirm", action: selectDifficulty)
            .padding()
            .font(.body)
            .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
            .foregroundColor(Color.black)
            .cornerRadius(6)
       }.padding()
    }

    func selectDifficulty() {
        let newDifficulty = oldDifficultyIndex + 1
        difficultySelectionIsPresenting.toggle()
        UserDefaults.standard.setDifficulty(value: newDifficulty)
    }
 }
