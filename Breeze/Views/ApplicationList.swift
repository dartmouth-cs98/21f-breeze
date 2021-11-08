//
//  ApplicationList.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/7/21.
//

import Foundation
import FamilyControls
import DeviceActivity
import SwiftUI
import ManagedSettings

@available(iOS 15.0, *)
@objc class ApplicationAsNSData: NSObject, NSCoding {
    let application: Application

    init(application: Application) {
        self.application = application
    }
    required init(coder decoder: NSCoder) {
        self.application = decoder.decodeObject(forKey: "application") as! Application
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(application, forKey: "application")
    }
}
