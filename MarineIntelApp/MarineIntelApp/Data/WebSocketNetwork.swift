//
//  WebSocketNetwork.swift
//  MarineIntelApp
//

import Foundation

// MARK: - WebSocketNetwork
class WebSocketNetwork: NSObject, URLSessionWebSocketDelegate {

    private let API_KEY = "f61c6242499febc6da1e0642529332e50523c89f"
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pendingBoundingBox: BoundingBoxModel?
    private var isConnected = false
    private var shouldReconnect = true
    private var reconnectAttempts = 0

    func connect(boundingBox: BoundingBoxModel) {
        shouldReconnect = true
        reconnectAttempts = 0
        pendingBoundingBox = boundingBox
        openConnection()
    }

    private func openConnection() {
        let url = URL(string: "wss://stream.aisstream.io/v0/stream")!
        urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
        print("🔄 Connecting... attempt \(reconnectAttempts + 1)")
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        isConnected = true
        reconnectAttempts = 0
        print("✅ WebSocket connected")
        if let box = pendingBoundingBox {
            fetchRequest(boundingBox: box)
        }
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        isConnected = false
        let reasonStr = reason.flatMap { String(data: $0, encoding: .utf8) } ?? "unknown"
        print("🔌 WebSocket closed: \(closeCode) — \(reasonStr)")
        attemptReconnect()
    }

    private func attemptReconnect() {
        guard shouldReconnect else { return }
        reconnectAttempts += 1
        let delay = min(Double(reconnectAttempts) * 2.0, 30.0) // 2s, 4s, 6s... max 30s
        print("⏳ Reconnecting in \(delay)s...")
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self, self.shouldReconnect else { return }
            self.openConnection()
        }
    }

    func fetchRequest(boundingBox: BoundingBoxModel) {
        let worldBoundingBox = [
            [boundingBox.minLat, boundingBox.minLon],
            [boundingBox.maxLat, boundingBox.maxLon]
        ]
        let subscriptionMessage: [String: Any] = [
            "APIKey": API_KEY,
            "BoundingBoxes": [worldBoundingBox],
            "FilterMessageTypes": ["PositionReport", "ShipStaticData"]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: subscriptionMessage)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error {
                        print("❌ Send error: \(error)")
                    } else {
                        print("📤 Subscription sent successfully")
                    }
                }
            }
        } catch {
            print("❌ Wrong JSON: \(error)")
        }
    }

    func receiveResponse(completion: @escaping (AISResponse) -> Void) {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                let data: Data?
                switch message {
                case .string(let text): data = text.data(using: .utf8)
                case .data(let d):      data = d
                @unknown default:       data = nil
                }

                if let data,
                   let response = self.decodeResponse(data: data),
                   response.messageType == "ShipStaticData" || response.messageType == "PositionReport",
                   response.metaData != nil {
                    completion(response)
                }

                self.receiveResponse(completion: completion)

            case .failure(let error):
                print("❌ WebSocket receive error: \(error)")
                self.isConnected = false
                self.attemptReconnect()
                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                    if self.isConnected {
                        self.receiveResponse(completion: completion)
                    }
                }
            }
        }
    }

    private func decodeResponse(data: Data) -> AISResponse? {
        do {
            let response = try JSONDecoder().decode(AISResponse.self, from: data)
            print("📨 MessageType: \(response.messageType) | Ship: \(response.metaData?.shipName ?? "nil")")
            return response
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "non-utf8"
            print("❌ Decode error: \(error)")
            print("📄 Raw JSON: \(raw.prefix(500))")
            return nil
        }
    }
    

    func disconnect() {
        shouldReconnect = false
        isConnected = false
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("🛑 WebSocket disconnected manually")
    }
}
