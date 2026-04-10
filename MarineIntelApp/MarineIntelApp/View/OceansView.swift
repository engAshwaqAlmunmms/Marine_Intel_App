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
    let subtitle: String
    let icon: String
    let boundingBox: BoundingBoxModel
}

struct OceansView: View {
    
    var onSelect: (BoundingBoxModel, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    private let backgroundDark  = Color(red: 0.05, green: 0.09, blue: 0.16)
    private let cardBackground  = Color(red: 0.08, green: 0.13, blue: 0.22)
    private let cardStroke      = Color(red: 0.15, green: 0.25, blue: 0.40)
    private let chevronBg       = Color(red: 0.12, green: 0.20, blue: 0.32)

    private var isAr: Bool { appLanguage == "ar" }

    // MARK: - Regions

    var oceans: [OceanModel] {[
        OceanModel(
            title:    isAr ? "المحيط الأطلسي": "Atlantic Ocean",
            subtitle: isAr ? "٧٠+ ألف سفينة": "70k+ vessels",
            icon: "globe.americas.fill",
            boundingBox: BoundingBoxModel(minLat: -60, maxLat: 70, minLon: -80, maxLon: 20)
        ),
        OceanModel(
            title:    isAr ? "المحيط الهادئ": "Pacific Ocean",
            subtitle: isAr ? "أكبر محيط في العالم": "World's largest ocean",
            icon: "globe.asia.australia.fill",
            boundingBox: BoundingBoxModel(minLat: -60, maxLat: 65, minLon: 100, maxLon: 180)
        ),
        OceanModel(
            title:    isAr ? "المحيط الهندي": "Indian Ocean",
            subtitle: isAr ? "طرق التجارة الآسيوية": "Asian trade routes",
            icon: "globe.europe.africa.fill",
            boundingBox: BoundingBoxModel(minLat: -60, maxLat: 30, minLon: 20, maxLon: 120)
        ),
        OceanModel(
            title:    isAr ? "المحيط الجنوبي": "Southern Ocean",
            subtitle: isAr ? "حول القطب الجنوبي": "Around Antarctica",
            icon: "snowflake",
            boundingBox: BoundingBoxModel(minLat: -90, maxLat: -50, minLon: -180, maxLon: 180)
        ),
        OceanModel(
            title:    isAr ? "المحيط المتجمد الشمالي"  : "Arctic Ocean",
            subtitle: isAr ? "المياه القطبية الشمالية" : "Northern polar waters",
            icon: "thermometer.snowflake",
            boundingBox: BoundingBoxModel(minLat: 65, maxLat: 90, minLon: -180, maxLon: 180)
        ),
    ]}

    var seas: [OceanModel] {[
        OceanModel(
            title:    isAr ? "مضيق هرمز": "Strait of Hormuz",
            subtitle: isAr ? "٢٠٪ من نفط العالم": "20% of world's oil",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 24.0, maxLat: 27.5, minLon: 54.0, maxLon: 60.0)
        ),
        OceanModel(
            title:    isAr ? "البحر الأحمر": "Red Sea",
            subtitle: isAr ? "ممر قناة السويس": "Suez Canal corridor",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 10.0, maxLat: 32.0, minLon: 30.0, maxLon: 46.0)
        ),
        OceanModel(
            title:    isAr ? "خليج عدن": "Gulf of Aden",
            subtitle: isAr ? "بوابة المحيط الهندي": "Indian Ocean gateway",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 11.0, maxLat: 15.0, minLon: 43.0, maxLon: 52.0)
        ),
        OceanModel(
            title:    isAr ? "البحر المتوسط": "Mediterranean Sea",
            subtitle: isAr ? "بحر التجارة الأوروبية": "European trade sea",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 30.0, maxLat: 46.0, minLon: -6.0, maxLon: 36.0)
        ),
        OceanModel(
            title:    isAr ? "بحر الشمال": "North Sea",
            subtitle: isAr ? "أكثر الممرات ازدحاماً": "Busiest shipping lane",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 51.0, maxLat: 61.0, minLon: -4.0, maxLon: 13.0)
        ),
        OceanModel(
            title:    isAr ? "بحر الصين الجنوبي": "South China Sea",
            subtitle: isAr ? "تجارة شرق آسيا": "East Asia trade hub",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 0.0, maxLat: 25.0, minLon: 105.0, maxLon: 122.0)
        ),
        OceanModel(
            title:    isAr ? "خليج المكسيك": "Gulf of Mexico",
            subtitle: isAr ? "ممرات النفط الأمريكية": "US oil corridors",
            icon: "ferry.fill",
            boundingBox: BoundingBoxModel(minLat: 18.0, maxLat: 31.0, minLon: -97.0, maxLon: -80.0)
        ),
        OceanModel(
            title:    isAr ? "قناة السويس": "Suez Canal",
            subtitle: isAr ? "أقصر طريق أوروبا-آسيا" : "Europe-Asia shortcut",
            icon: "arrow.up.arrow.down",
            boundingBox: BoundingBoxModel(minLat: 29.5, maxLat: 32.5, minLon: 32.0, maxLon: 33.5)
        ),
    ]}

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundDark.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {

                    // Header
                    VStack(spacing: 8) {
                        Text(isAr ? "المناطق البحرية" : "Maritime Regions")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text(isAr
                             ? "اختر منطقة لمراقبة حركة الملاحة البحرية النشطة."
                             : "Select a region to monitor active vessel traffic.")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Oceans section
                    sectionHeader(title: isAr ? "المحيطات" : "Oceans")
                    VStack(spacing: 10) {
                        ForEach(oceans) { ocean in
                            regionRow(ocean: ocean)
                        }
                    }
                    .padding(.horizontal, 20)

                    // Seas & Straits section
                    sectionHeader(title: isAr ? "البحار والمضايق" : "Seas & Straits")
                    VStack(spacing: 10) {
                        ForEach(seas) { sea in
                            regionRow(ocean: sea)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    // MARK: - Section Header

    @ViewBuilder
    func sectionHeader(title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.4))
                .tracking(1.5)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 10)
    }

    // MARK: - Region Row

    @ViewBuilder
    func regionRow(ocean: OceanModel) -> some View {
        Button(action: {
            onSelect(ocean.boundingBox, ocean.title)
            dismiss()
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(chevronBg)
                        .frame(width: 42, height: 42)
                    Image(systemName: ocean.icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(ocean.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(ocean.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.45))
                }
                Spacer()
                Image(systemName: isAr ? "chevron.left" : "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
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

// MARK: - Button Style

struct OceanRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Color Extension

extension Color {
    public static func colorFromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            return Color.black
        }
        return Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
