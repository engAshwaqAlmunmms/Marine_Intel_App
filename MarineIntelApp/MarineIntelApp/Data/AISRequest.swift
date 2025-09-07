//
//  AISRequest.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 4.09.2025.
//

import Foundation

struct AISRequest {
    
    let BoundingBoxes: [BoundingBox]
}

struct BoundingBox: Codable {
    let TopLeft: Coordinate
    let BottomRight: Coordinate
}

struct Coordinate: Codable {
    let Latitude: Double
    let Longitude: Double
}
