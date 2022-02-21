//
//  TempTestingDataView.swift
//  Breeze
//
//  Created by Katherine Taylor on 2/16/22.
//

import SwiftUI

struct TempTestingDataView: View {
    @Binding var isPresenting: Bool
    @State private var userData = UserDefaults.standard.getEachDayPhoneUsage()
    @State private var counter = 0
    
    var body: some View {
        ZStack {
            Color.init(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
            VStack {
                HStack {
                    // Back arrow which takes user back to profile screen
                    Button(action: {
                        withAnimation {
                            isPresenting.toggle()
                        }
                    }, label: {
                        // credit IconArchive https://iconarchive.com/show/ios7-icons-by-icons8/arrows-back-icon.html
                        Image("Arrows-Back-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding()
                    })
                    Spacer()
                }
                Text("On this view")
                    .font(.body)
                    .multilineTextAlignment(.center)
               }
                }
            }
        }
