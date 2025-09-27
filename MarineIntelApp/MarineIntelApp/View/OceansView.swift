//
//  OceansView.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 19.09.2025.
//

import SwiftUI
import MapKit

struct BoundingBoxModel {
    let minLat: Double
    let maxLat: Double
    let minLon: Double
    let maxLon: Double
    
    public func toRegion() -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat,
            longitudeDelta: maxLon - minLon
        )
        return MKCoordinateRegion(center: center, span: span)
    }
}

struct OceanModel: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let boundingBox: BoundingBoxModel
}

struct OceansView: View {
    
    let columns = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180))
    ]
    
    var onSelect: (BoundingBoxModel) -> Void
    @Environment(\.dismiss) private var dismiss

    let oceans: [OceanModel] = [
        OceanModel(title: "Pacific Ocean", image: "Pacific-Ocean",
                   boundingBox: BoundingBoxModel(minLat: -60, maxLat: 65, minLon: 100, maxLon: 180)),
        OceanModel(title: "Atlantic Ocean", image: "Atlantic-Ocean",
                   boundingBox: BoundingBoxModel(minLat: -60, maxLat: 70, minLon: -70, maxLon: 20)),
        OceanModel(title: "Indian Ocean", image: "Indian-Ocean",
                   boundingBox: BoundingBoxModel(minLat: -60, maxLat: 30, minLon: 20, maxLon: 120)),
        OceanModel(title: "Southern Ocean", image: "Southern-Ocean",
                   boundingBox: BoundingBoxModel(minLat: -90, maxLat: -50, minLon: -180, maxLon: 180)),
        OceanModel(title: "Arctic Ocean", image: "Arctic-Ocean",
                   boundingBox: BoundingBoxModel(minLat: 65, maxLat: 90, minLon: -180, maxLon: 180))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Oceans")
                .foregroundColor(Color.colorFromHex("003262"))
                .font(.largeTitle)
                .padding([.leading, .trailing], 15)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(oceans) { ocean in
                    Button(action: {
                        onSelect(ocean.boundingBox)
                        dismiss()
                    }) {
                        oceansView(title: ocean.title, image: ocean.image)
                    }
                }
            }
        }
        .background(Color.colorFromHex("F0F8FF"))
    }
    
    @ViewBuilder
    func oceansView(title: String, image: String) -> some View {
        VStack {
            Image(image)
                .resizable()
                .foregroundColor(Color.colorFromHex("6CB4EE"))
                .frame(width: 160, height: 150)
            Text(title)
                .foregroundColor(Color.colorFromHex("003262"))
                .font(.title3)
                .padding(.bottom)
                .lineLimit(1)
        }
        .background(Color.colorFromHex("B9D9EB"))
        .cornerRadius(15)
        .padding()
    }
}

extension Color {
    
    public static func colorFromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RRGGBB
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            return Color.black
        }
        
        return Color(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}

