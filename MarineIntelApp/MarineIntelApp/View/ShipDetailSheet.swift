//
//  ShipDetailSheet.swift
//  MarineIntelApp
//

import SwiftUI

struct ShipDetailSheet: View {

    let ship: Ship
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: Header
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.10, green: 0.18, blue: 0.30))
                            .frame(width: 56, height: 56)
                        Image(systemName: "ferry.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ship.name.isEmpty ? "Unknown Vessel" : ship.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    ShipTypeBadge(type: ship.shipType)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
                Divider()
                    .background(Color.white.opacity(0.1))

                // MARK: Identity
                SectionHeader(title: appLanguage == "ar" ? "الهوية" : "Identity")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
                    InfoCell(icon: "antenna.radiowaves.left.and.right", label: appLanguage == "ar" ? "رقم تعريف الخدمة المتنقلة البحرية" : "MMSI",value: "\(ship.id)")
                    InfoCell(icon: "radio.fill", label: appLanguage == "ar" ? "إشارة النداء" :"Call Sign", value: ship.callSign ?? "")
                }
                .padding(.bottom, 8)

                // MARK: Voyage
                SectionHeader(title: appLanguage == "ar" ? "رحلة السفينة" : "Voyage")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
                    InfoCell(icon: "location.fill", label: appLanguage == "ar" ? "خط العرض" :"Latitude", value: String(format: "%.4f°", ship.coordinate.latitude))
                    InfoCell(icon: "location.fill", label: appLanguage == "ar" ? "خط الطول" :"Longitude", value: String(format: "%.4f°", ship.coordinate.longitude))
                    InfoCell(icon: "building.2.fill", label: appLanguage == "ar" ? "الوجهة" :"Destination", value: ship.destination ?? "")
                    InfoCell(icon: "clock.fill", label: appLanguage == "ar" ? "وقت الوصول المتوقع" :"ETA", value: ship.eta ?? "")
                    InfoCell(icon: "speedometer",  label: appLanguage == "ar" ? "السرعة" :"Speed",   value: ship.speed.map   { String(format: "%.1f kn", $0) } ?? "N/A")
                    InfoCell(icon: "safari.fill",  label: appLanguage == "ar" ? "العنوان" :"Heading", value: ship.heading.map { "\($0)°" } ?? "N/A")
                }
                .padding(.bottom, 8)

                // MARK: Dimensions
                SectionHeader(title: appLanguage == "ar" ? "أبعاد السفينة" :"Dimensions")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
                    InfoCell(icon: "ruler",                label: appLanguage == "ar" ? "الطول" :"Length",  value: String(ship.length ?? 0))
                    InfoCell(icon: "arrow.left.and.right", label: appLanguage == "ar" ? "العرض" :"Width",   value: String(ship.width ?? 0))
                    InfoCell(icon: "water.waves",          label: appLanguage == "ar" ? "غاطس السفينة" :"Draught", value: String(format: "%.1f m", ship.draught ?? 0))
                }
                .padding(.bottom, 8)

                // MARK: Last Update
                SectionHeader(title: appLanguage == "ar" ? "آخر تحديث" :"Last Update")
                InfoCell(
                    icon: "clock.arrow.circlepath",
                    label: appLanguage == "ar" ? "تم الاستلام" :"Received",
                    value: DateFormatter.localizedString(from: ship.timestamp, dateStyle: .medium, timeStyle: .short)
                )
                .padding(.bottom, 8)

                Spacer(minLength: 32)
            }
        }
        .background(Color(red: 0.04, green: 0.09, blue: 0.18))
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.gray)
            .tracking(1)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 6)
    }
}

// MARK: - Info Cell

struct InfoCell: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(0.5)
            }
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color(red: 0.07, green: 0.13, blue: 0.22))
        .overlay(
            Rectangle()
                .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
        )
    }
}

// MARK: - Ship Type Badge

struct ShipTypeBadge: View {
    let type: Int?
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var label: String {
        guard let type else { return appLanguage == "ar" ? "غير معروف" :"Unknown" }
        switch type {
        case 20...29: return appLanguage == "ar" ? "سفن المرافقة والمساعدة" : "WIG"
        case 30:      return appLanguage == "ar" ? "صيد الأسماك" : "Fishing"
        case 31...32: return appLanguage == "ar" ? "سحب السفن" :"Towing"
        case 33:      return appLanguage == "ar" ? "تجريف" : "Dredging"
        case 34:      return appLanguage == "ar" ? "غوص" : "Diving"
        case 35:      return appLanguage == "ar" ? "عسكرية" : "Military"
        case 36:      return appLanguage == "ar" ? "إبحار شراعي" : "Sailing"
        case 37:      return appLanguage == "ar" ? "ترفيهية" : "Pleasure"
        case 40...49: return appLanguage == "ar" ? "سريعة السرعة" : "High Speed"
        case 50:      return appLanguage == "ar" ? "سفينة قائد الميناء" : "Pilot"
        case 51:      return appLanguage == "ar" ? "بحث وإنقاذ" : "SAR"
        case 52:      return appLanguage == "ar" ? "سفينة قاطرة" : "Tug"
        case 53:      return appLanguage == "ar" ? "خدمة الميناء" : "Port Tender"
        case 55:      return appLanguage == "ar" ? "إنفاذ القانون" : "Law Enforce"
        case 60...69: return appLanguage == "ar" ? "ركاب" : "Passenger"
        case 70...79: return appLanguage == "ar" ? "حمولات / بضائع" : "Cargo"
        case 80...89: return appLanguage == "ar" ? "ناقلة نفط" : "Tanker"
        case 90...99: return appLanguage == "ar" ? "اخرى" :"Other"
        default:      return "Type \(type)"
        }
    }

    var color: Color {
        guard let type else { return .gray }
        switch type {
        case 60...69: return .blue
        case 70...79: return .orange
        case 80...89: return .red
        case 35:      return .purple
        case 51:      return .green
        default:      return .gray
        }
    }

    var body: some View {
        Text(label)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15))
            .cornerRadius(20)
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.4), lineWidth: 0.5)
            )
    }
}
