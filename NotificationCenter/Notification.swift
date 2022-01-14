//
//  Notification.swift
//  NotificationCenter
//
//  Created by John Weingart on 1/11/22.
//

import Foundation


public struct Notification: Codable {
    private(set) public var id: String;
    private(set) public var time: Date;

    public init(id: String){
        self.id = id
        self.time = Date()
    }
}
