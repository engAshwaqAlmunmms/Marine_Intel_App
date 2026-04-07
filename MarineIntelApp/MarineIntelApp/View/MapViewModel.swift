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
    @Published var boundingBox: BoundingBoxModel?
    @Published var oceanName: String = ""
    
    func startWebSocket() {
        webSocket = WebSocketNetwork()
        webSocket.connect()
        webSocket.receiveResponse { [weak self] response in
            guard let meta = response.metaData,
                  let shipStaticData = response.message?.shipStaticData else { return }
            
            let time = ISO8601DateFormatter().date(from: meta.timeUtc) ?? Date()
            
            let ship = Ship(
                name:meta.shipName.cleanedAIS,
                mmsi: meta.mmsi,
                coordinate: CLLocationCoordinate2D(latitude: meta.latitude, longitude: meta.longitude),
                timestamp:time,
                callSign: shipStaticData.callSign.cleanedAIS,
                destination: shipStaticData.destination.cleanedAIS,
                eta: shipStaticData.eta.formatted,
                shipType: shipStaticData.type,
                draught: shipStaticData.maximumStaticDraught,
                length: shipStaticData.dimension.length,
                width: shipStaticData.dimension.width
            )
            DispatchQueue.main.async {
                if let index = self?.ships.firstIndex(where: { $0.mmsi == meta.mmsi }) {
                    self?.ships[index] = ship
                } else {
                    self?.ships.append(ship)
                }
            }
        }
    }
    
    func stopWebSocket() {
        webSocket.disconnect()
    }
}
