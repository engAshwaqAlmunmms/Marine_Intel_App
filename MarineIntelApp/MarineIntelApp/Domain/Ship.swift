//
//  Ship.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 7.09.2025.
//

import Foundation
import MapKit

struct Ship: Identifiable {
    let id = UUID()
    var name: String
    let mmsi: Int
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    var callSign: String
    var destination: String
    var eta: String
    var shipType: Int
    var draught: Double
    var length: Int
    var width: Int
}
