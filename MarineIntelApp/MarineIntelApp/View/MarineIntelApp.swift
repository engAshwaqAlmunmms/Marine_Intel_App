//
//  MarineIntelAppApp.swift
//  MarineIntelApp
//
//  Created by Ashwaq Alghamdi on 4.09.2025.
//

import SwiftUI

@main
struct MarineIntelApp: App {
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some Scene {
        WindowGroup {
            ShipMapView()
                .environment(\.locale, Locale(identifier: appLanguage))
                .onAppear {
                    UserDefaults.standard.set([appLanguage], forKey: "AppleLanguages")
                }
        }
    }
}
