import SwiftUI
import MapKit

struct Ship: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let timestamp: Date
}

class MapViewModel: ObservableObject {
    @Published var ships: [Ship] = []
    private var webSocket: WebSocketNetwork?

    func startWebSocket() {
        if webSocket == nil {
            webSocket = WebSocketNetwork()
        }

        webSocket?.connect()

        webSocket?.receiveResponse { [weak self] response in
            guard let meta = response.metaData else { return }

            let name = meta.shipName ?? "Unknown"
            let lat = meta.latitude ?? 0
            let lon = meta.longitude ?? 0
            let time = ISO8601DateFormatter().date(from: meta.time ?? "") ?? Date()
            let ship = Ship(name: name,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            timestamp: time)

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

struct ShipMapView: View {
    @StateObject var vm = MapViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25, longitude: 55),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    
    var body: some View {
        Map(initialPosition: .region(region)) {
            ForEach(vm.ships) { ship in
                Annotation(ship.name, coordinate: ship.coordinate) {
                    VStack {
                        Image(systemName: "ferry.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text(ship.name)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .onAppear {
            vm.startWebSocket()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ShipMapView()
}
