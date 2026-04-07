import SwiftUI
import MapKit

// MARK: - Main View
struct ShipMapView: View {
    @StateObject var vm = MapViewModel()
    @State private var selectedShip: Ship? = nil
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ShipMap(
                    ships: vm.ships,
                    region: $region,
                    onSelectShip: { ship in
                        selectedShip = ship
                    }
                )
                HStack(spacing: 12) {
                    DestinationButton { box, oceanName in
                        vm.stopWebSocket()
                        vm.ships.removeAll()
                        vm.boundingBox = box
                        region = box.toRegion()
                        vm.oceanName = oceanName
                    }
                    
                    LanguageButton()
                }
            }
            .onAppear {
//                vm.startWebSocket()
            }
            .modifier(NavigationBarStyle(title: vm.oceanName.isEmpty ? appLanguage == "ar" ? "المحيط الهادي" : "Pacific Ocean" : vm.oceanName))
            .sheet(item: $selectedShip) { ship in
                ShipDetailSheet(ship: ship)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ShipMapView()
}

// MARK: - Map View
struct ShipMap: View {
    
    var ships: [Ship]
    @Binding var region: MKCoordinateRegion
    var onSelectShip: (Ship) -> Void
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: ships
        ) { ship in
            MapAnnotation(coordinate: ship.coordinate) {
                ShipAnnotationView(ship: ship)
                    .onTapGesture {
                        onSelectShip(ship)
                    }
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

// MARK: - Annotation View
struct ShipAnnotationView: View {
    
    let ship: Ship
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "ferry.fill")
                .foregroundColor(.white)
            
            Text(ship.name)
                .font(.caption)
                .padding(4)
                .foregroundColor(.white)
                .background(
                    Color(red: 0.04, green: 0.09, blue: 0.18)
                        .opacity(0.92)
                )
                .cornerRadius(4)
        }
    }
}

// MARK: - Language Button
struct LanguageButton: View {
    
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        Button(action: {
            appLanguage = appLanguage == "en" ? "ar" : "en"
        }) {
            ZStack() {
                Circle()
                    .fill(Color(red: 0.07, green: 0.13, blue: 0.22))
                    .overlay(
                        Circle()
                            .stroke(
                                Color(red: 0.18, green: 0.28, blue: 0.42),
                                lineWidth: 1
                            )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
                
                Image(systemName: "globe")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 34)
    }
}

// MARK: - Destination Button
struct DestinationButton: View {
    
    var onSelect: (BoundingBoxModel, String) -> Void
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        NavigationLink(
            destination: OceansView { box, oceanName in
                onSelect(box, oceanName)
            }
        ) {
            HStack(spacing: 8) {
                Image(systemName: "map.fill")
                    .font(.system(size: 15, weight: .semibold))
                
                Text(appLanguage == "ar" ? "اختر الوجهة" :"Select Destination")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(Color(red: 0.07, green: 0.13, blue: 0.22))
                    .overlay(
                        Capsule()
                            .stroke(
                                Color(red: 0.18, green: 0.28, blue: 0.42),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
        }
        .padding(.bottom, 36)
    }
}

// MARK: - Navigation Bar Style
struct NavigationBarStyle: ViewModifier {
    
    let title: String
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    
                    Text(title.isEmpty ? appLanguage == "ar" ? "المحيطات العالمية": "Global Oceans" : title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(
                Color(red: 0.04, green: 0.09, blue: 0.18).opacity(0.92),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
