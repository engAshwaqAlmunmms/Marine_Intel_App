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
        webSocket.connect(boundingBox: boundingBox ?? BoundingBoxModel(
            minLat: -60, maxLat: 65, minLon: 100, maxLon: 180
        ))
        listenForShips()
    }

    func listenForShips() {
        webSocket.receiveResponse { [weak self] response in
            guard let self, let meta = response.metaData else { return }

            let time = ISO8601DateFormatter().date(from: meta.timeUtc) ?? Date()
            let staticData  = response.message?.shipStaticData
            let posReport   = response.message?.positionReport

            DispatchQueue.main.async {
                if let index = self.ships.firstIndex(where: { $0.id == meta.mmsi }) {
                    self.ships[index].coordinate = CLLocationCoordinate2D(
                        latitude: meta.latitude,
                        longitude: meta.longitude
                    )
                    self.ships[index].timestamp = time
                    
                    if let pos = posReport {
                        self.ships[index].speed            = pos.sog
                        self.ships[index].heading          = pos.trueHeading
                        self.ships[index].navigationStatus = pos.navigationalStatus
                    }
                    
                    if let s = staticData {
                        self.ships[index].imo         = s.imoNumber > 0 ? "\(s.imoNumber)" : nil
                        self.ships[index].callSign     = s.callSign.cleanedAIS.isEmpty ? nil : s.callSign.cleanedAIS
                        self.ships[index].destination  = s.destination.cleanedAIS.isEmpty ? nil : s.destination.cleanedAIS
                        self.ships[index].eta          = s.eta.formatted == "N/A" ? nil : s.eta.formatted
                        self.ships[index].shipType     = s.type
                        self.ships[index].draught      = s.maximumStaticDraught > 0 ? s.maximumStaticDraught : nil
                        self.ships[index].length       = s.dimension.length > 0 ? s.dimension.length : nil
                        self.ships[index].width        = s.dimension.width > 0 ? s.dimension.width : nil
                    }
                } else if self.ships.count < 300 {
                    let ship = Ship(
                        id: meta.mmsi,
                        name: meta.shipName.cleanedAIS,
                        coordinate:  CLLocationCoordinate2D(latitude: meta.latitude, longitude: meta.longitude),
                        timestamp:   time,
                        imo: staticData.flatMap { $0.imoNumber > 0 ? "\($0.imoNumber)" : nil },
                        callSign: staticData.flatMap { $0.callSign.cleanedAIS.isEmpty ? nil : $0.callSign.cleanedAIS },
                        destination: staticData.flatMap { $0.destination.cleanedAIS.isEmpty ? nil : $0.destination.cleanedAIS },
                        eta: staticData.flatMap { $0.eta.formatted == "N/A" ? nil : $0.eta.formatted },
                        shipType: staticData?.type,
                        flag: nil,
                        draught: staticData.flatMap { $0.maximumStaticDraught > 0 ? $0.maximumStaticDraught : nil },
                        length: staticData.flatMap { $0.dimension.length > 0 ? $0.dimension.length : nil },
                        width: staticData.flatMap { $0.dimension.width > 0 ? $0.dimension.width : nil },
                        speed: posReport?.sog,
                        heading: posReport?.trueHeading,
                        navigationStatus: posReport?.navigationalStatus
                    )
                    self.ships.append(ship)
                }
            }
        }
    }
    
    func stopWebSocket() {
        webSocket.disconnect()
    }
}

// MARK: - String Helper
extension String {
    var cleanedAIS: String {
        self.replacingOccurrences(of: "@", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
