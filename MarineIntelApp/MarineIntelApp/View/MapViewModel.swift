//
//  MapViewModel.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 7.09.2025.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var ships: [Ship] = []
    @Published var webSocket: WebSocketNetwork = WebSocketNetwork()
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 16.0, longitude: 55.0), // مركز بحر العرب تقريبًا
            span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0) // Zoom Out كبير
        )
    )
    
    func startWebSocket() {
        webSocket = WebSocketNetwork()
        webSocket.connect()
        webSocket.receiveResponse { [weak self] response in
            guard let meta = response.metaData else { return }
            let name = meta.shipName ?? "Unknown"
            let lat = meta.latitude ?? 0
            let lon = meta.longitude ?? 0
            let time = ISO8601DateFormatter().date(from: meta.time ?? "") ?? Date()
            let ship = Ship(name: name,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            timestamp: time)
            print("🛳 Received ship: \(ship.name)")
            DispatchQueue.main.async {
                if let index = self?.ships.firstIndex(where: { $0.name == name }) {
                    self?.ships[index] = ship
                } else {
                    self?.ships.append(ship)
                }
            }
        }
    }
}
