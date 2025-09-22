//
//  OceansView.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 19.09.2025.
//

import SwiftUI


struct OceansView: View {
    let columns = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Oceans")
                .foregroundColor(Color.colorFromHex("003262"))
                .font(.largeTitle)
                .padding([.leading, .trailing])
            LazyVGrid(columns: columns, spacing: 0) {
                oceansView(title: "Pacific Ocean", image: "Pacific-Ocean")
                oceansView(title: "Atlantic Ocean", image: "Atlantic-Ocean")
                oceansView(title: "Indian Ocean", image: "Indian-Ocean")
                oceansView(title: "Southern Ocean", image: "Southern-Ocean")
                oceansView(title: "Arctic Ocean", image: "Arctic-Ocean")
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

#Preview {
    OceansView()
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

