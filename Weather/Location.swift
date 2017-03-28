//
//  Location.swift
//  Weather
//
//  Created by Kryg Tomasz on 27.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation

enum CityType {
    case name
    case coordinates
}

class Location {
    
    private var type: CityType = .name
    private var latitude: String = ""
    private var longitude: String = ""
    private var name: String = ""
    var isLocalizedByDevice: Bool = false
    
    init(name: String?) {
        self.name = name ?? ""
        self.type = .name
    }
    
    init(latitude: Double?, longitude: Double?, isLocalizedByDevice: Bool = false) {
        guard let lat = latitude,
            let long = longitude else {
                self.latitude = "0"
                self.longitude = "0"
                type = .coordinates
                return
        }
        self.latitude = "\(lat)"
        self.longitude = "\(long)"
        self.type = .coordinates
        self.isLocalizedByDevice = isLocalizedByDevice
    }
    
    func getStringForRequest() -> String {
        var location = ""
        switch type {
        case .coordinates:
            location = "lat=\(latitude)&lon=\(longitude)"
        case .name:
            location = "q="+name
        }
        return location
    }
    
}
