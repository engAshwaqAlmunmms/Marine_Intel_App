//
//  WebSocketNetwork.swift
//  MarineIntelApp
//

import Foundation

// MARK: - WebSocketNetwork

class WebSocketNetwork {

    private let API_KEY = "f61c6242499febc6da1e0642529332e50523c89f"
    private var webSocketTask: URLSessionWebSocketTask?

    func connect(boundingBox: BoundingBoxModel) {
        let url = URL(string: "wss://stream.aisstream.io/v0/stream")!
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        fetchRequest(boundingBox: boundingBox)
    }

    func fetchRequest(boundingBox: BoundingBoxModel) {
        let worldBoundingBox = [
            [boundingBox.minLat, boundingBox.minLon],
            [boundingBox.maxLat, boundingBox.maxLon]
        ]
        let subscriptionMessage: [String: Any] = [
            "APIKey": API_KEY,
            "BoundingBoxes": [worldBoundingBox],
            "FilterMessageTypes": ["ShipStaticData"]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscriptionMessage)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error {
                        print("❌ Send error: \(error)")
                    }
                }
            }
        } catch {
            print("❌ Wrong JSON: \(error)")
        }
    }

    func receiveResponse(completion: @escaping (AISResponse) -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                let data: Data?
                switch message {
                case .string(let text): data = text.data(using: .utf8)
                case .data(let d):      data = d
                @unknown default:       data = nil
                }

                if let data,
                   let response = self?.decodeResponse(data: data),
                   response.messageType == "ShipStaticData",
                   response.message?.shipStaticData != nil {
                    completion(response)
                }

                self?.receiveResponse(completion: completion)

            case .failure(let error):
                print("❌ WebSocket receive error: \(error)")
            }
        }
    }

    private func decodeResponse(data: Data) -> AISResponse? {
        do {
            return try JSONDecoder().decode(AISResponse.self, from: data)
        } catch {
            // print raw string to debug unexpected payloads
            let raw = String(data: data, encoding: .utf8) ?? "non-utf8 data"
            print("❌ JSON decode error: \(error.localizedDescription)\nRaw: \(raw.prefix(300))")
            return nil
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
