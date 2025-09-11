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
    let name: String
    let coordinate: CLLocationCoordinate2D
    let timestamp: Date
}
