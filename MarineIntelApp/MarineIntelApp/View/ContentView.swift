import SwiftUI
import MapKit

struct ShipMapView: View {
    @StateObject var vm = MapViewModel()
    
    
    
    var body: some View {
        GeometryReader { geo in
            Map(position: $vm.cameraPosition) {
                    ForEach(vm.ships) { ship in
                        Annotation(ship.name, coordinate: ship.coordinate) {
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
                }
                .background(Color.clear)
        }
        .onAppear {
            vm.startWebSocket()
        }
    }
}
