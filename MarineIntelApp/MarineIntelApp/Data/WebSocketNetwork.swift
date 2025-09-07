//
//  WebSocketNetwork.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 4.09.2025.
//

import Foundation

class WebSocketNetwork {
    
    private let API_KEY = "f61c6242499febc6da1e0642529332e50523c89f"
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "wss://stream.aisstream.io/v0/stream")!
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        fetchRequest()
    }
    
    private func fetchRequest() {
        let subscriptionMessage: [String: Any] = [
            "APIKey": API_KEY,
            "BoundingBoxes": [
                [[25.835302, -80.207729],
                 [25.602700, -79.879297]],
                [[33.772292, -118.356139],
                 [33.673490, -118.095731]]
            ],
            "FilterMessageTypes": ["PositionReport"] 
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscriptionMessage)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    print("❌ something error \(error.debugDescription)")
                }
            }
        } catch {
            print("❌ wrong JSON: \(error)")
        }
    }

    func receiveResponse(completion: @escaping (AISResponse) -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let response = self?.decodeResponse(data: data) {
                        completion(response)
                    }
                default:
                    break
                }
                self?.receiveResponse(completion: completion) // continue listening
            case .failure(let error):
                print("❌ error in receive WebSocket: \(error)")
            }
        }
    }
    
    private func decodeResponse(data: Data) -> AISResponse {
        do {
            let response = try JSONDecoder().decode(AISResponse.self, from: data)
            return response
        } catch {
            print("❌ JSON decode error: \(error.localizedDescription)")
            return AISResponse(messageType: "", metaData: nil)
        }
    }
}
