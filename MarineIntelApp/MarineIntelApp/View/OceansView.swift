//
//  OceansView.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 19.09.2025.
//

import SwiftUI


struct OceansView: View {
    
    var onSelect: (BoundingBoxModel, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    // Dark navy background color
    private let backgroundDark = Color(red: 0.05, green: 0.09, blue: 0.16)
    // Slightly lighter card background
    private let cardBackground = Color(red: 0.08, green: 0.13, blue: 0.22)
    // Card border/stroke color
    private let cardStroke = Color(red: 0.15, green: 0.25, blue: 0.40)
    // Chevron circle background
    private let chevronBackground = Color(red: 0.12, green: 0.20, blue: 0.32)
    
    var oceans: [OceanModel] {
          let isAr = appLanguage == "ar"
          return [
              OceanModel(title: isAr ? "المحيط الأطلسي": "Atlantic Ocean",  image: "Atlantic-Ocean",
                         boundingBox: BoundingBoxModel(minLat: -60, maxLat: 70,  minLon: -70,  maxLon: 20)),
              OceanModel(title: isAr ? "المحيط الهادئ": "Pacific Ocean",   image: "Pacific-Ocean",
                         boundingBox: BoundingBoxModel(minLat: -60, maxLat: 65,  minLon: 100,  maxLon: 180)),
              OceanModel(title: isAr ? "المحيط الهندي": "Indian Ocean",    image: "Indian-Ocean",
                         boundingBox: BoundingBoxModel(minLat: -60, maxLat: 30,  minLon: 20,   maxLon: 120)),
              OceanModel(title: isAr ? "المحيط الجنوبي": "Southern Ocean",  image: "Southern-Ocean",
                         boundingBox: BoundingBoxModel(minLat: -90, maxLat: -50, minLon: -180, maxLon: 180)),
              OceanModel(title: isAr ? "المحيط المتجمد الشمالي" : "Arctic Ocean",    image: "Arctic-Ocean",
                         boundingBox: BoundingBoxModel(minLat: 65,  maxLat: 90,  minLon: -180, maxLon: 180))
          ]
      }
    
    var body: some View {
        ZStack {
            backgroundDark
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Header area
                VStack(spacing: 8) {
                    Text(appLanguage == "ar" ? "المحيطات العالمية": "Global Oceans")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    
                    Text(appLanguage == "ar" ? "اختر محيطًا لمراقبة حركة الملاحة البحرية النشطة وتفاصيل السفن." : "Select an ocean to monitor active maritime\n traffic and vessel details.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.top, 32)
                .padding(.bottom, 36)
                .padding(.horizontal, 24)
                
                // Ocean list
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(oceans) { ocean in
                            oceanRow(ocean: ocean)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    @ViewBuilder
    func oceanRow(ocean: OceanModel) -> some View {
        Button(action: {
            onSelect(ocean.boundingBox, ocean.title)
            dismiss()
        }) {
            HStack {
                Text(ocean.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                ZStack {
                    Circle()
                        .fill(chevronBackground)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(cardStroke, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(OceanRowButtonStyle())
    }
}

// Press animation for the row
struct OceanRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
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
