//
//  Note.swift
//  challenge-iOSDev
//
//  Created by Norberto Vasconcelos on 03/03/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import CoreLocation

public struct Note {
        
    public let body: String
    public let title: String
    public let location: Location
    public let createdAt: String
    public let uid: String
    
    public init(body: String,
                title: String,
                location: Location,
                createdAt: String,
                uid: String) {
        self.body = body
        self.title = title
        self.location = location
        self.createdAt = createdAt
        self.uid = uid
    }
    
    public init(body: String, title: String, location: Location) {
        self.init(body: body, title: title, location: location, createdAt: String(round(Date().timeIntervalSince1970 * 1000)), uid: NSUUID().uuidString)
    }
    
    public init(body: String, title: String, location: CLLocationCoordinate2D) {
        let newLocation = Location(location: location)
        self.init(body: body, title: title, location: newLocation, createdAt: String(round(Date().timeIntervalSince1970 * 1000)), uid: NSUUID().uuidString)
    }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.title == rhs.title &&
            lhs.body == rhs.body &&
            lhs.location == rhs.location &&
            lhs.createdAt == rhs.createdAt &&
            lhs.uid == rhs.uid
    }
}
