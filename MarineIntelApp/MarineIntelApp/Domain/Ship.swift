//
//  Ship.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 7.09.2025.
//

import Foundation
import MapKit

struct Ship: Identifiable {
    let id: Int
    var name: String
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    var imo: String?
    var callSign: String?
    var destination: String?
    var eta: String?
    var shipType: Int?
    var flag: String?
    var draught: Double?
    var length: Int?
    var width: Int?
    var speed: Double?
    var heading: Int?
    var navigationStatus: Int?
}
