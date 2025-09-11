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
    @Published var cameraPosition: MapCameraPosition? = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 21.4858, longitude: 39.1925),  // Jeddah coordinates
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
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
            print("🛳 Received ship: \(ship.name) at \(lat), \(lon)")
            DispatchQueue.main.async {
                if let index = self?.ships.firstIndex(where: { $0.name == name }) {
                    self?.ships[index] = ship
                } else {
                    self?.ships.append(ship)
                    if self?.cameraPosition == nil {
                        self?.cameraPosition = .region(MKCoordinateRegion(
                            center: ship.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                }
            }
            //print("🛳 Ship count: \(self?.ships.count ?? -1)")
        }
    }
}
