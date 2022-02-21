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
                            print("user data is")
                            //unpackData()
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
                let s = unpackData()
                Text("Weekly Screentime:")
                                .font(.body)
                                .multilineTextAlignment(.center)
                Text(s)
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
//                Text("On this view")
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                ForEach(userData) { data in
//                    Text(data)
//                        .padding()
//                }
//                List {
//                    while (counter < userData.endIndex) {
//                        Text(userData[counter])
//                    }
                }
            }
        }
    
//    func displayData() {
//        while (counter < userData.endIndex) {
//            Text(userData[counter])
//        }
//    }
    func unpackData() -> String {
        var string = ""

        //var daysOftheWeek:[String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        userData?.forEach { item in
            
            //let day = daysOftheWeek[item[0]]
            print(item)
            //print("The code is\(item.0)")
            let s = String(describing: item)
            let trimmed = s.components(separatedBy: .whitespacesAndNewlines).joined()
            string += trimmed
            string += "\n"
        
        }
        return string

                
    }
}
