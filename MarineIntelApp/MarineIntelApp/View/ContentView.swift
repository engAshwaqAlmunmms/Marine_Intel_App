import SwiftUI
import MapKit

struct ShipMapView: View {
    
    @StateObject var vm = MapViewModel()
    @State private var wavesCount = 0
    @State private var oceansPage  = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region,
                    annotationItems: vm.ships) { ship in
                    MapAnnotation(coordinate: ship.coordinate) {
                        VStack {
                            Image(systemName: "ferry.fill")
                                .foregroundColor(.blue)
                            Text(ship.name)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                    }
                }
                .preferredColorScheme(.dark)
                NavigationLink(destination:
                OceansView { box in
                    vm.stopWebSocket()
                    vm.boundingBox = box
                    region = box.toRegion()
                })
                {
                    ZStack {
                        Circle()
                            .fill(Color.colorFromHex("F0F8FF"))
                            .frame(width: 60, height: 60)
                        Image(systemName: "water.waves")
                            .resizable()
                            .foregroundColor(Color.colorFromHex("003262"))
                            .symbolEffect(.breathe, value: wavesCount)
                            .frame(width: 25, height: 25)
                    }
                    .position(x: 330, y: 700)
                }
                .buttonStyle(.plain)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                vm.startWebSocket()
            }
        }
    }
}
