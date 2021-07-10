//
//  NBAStatsApp.swift
//  NBAStats
//
//  Created by President Raindas on 07/07/2021.
//

import SwiftUI

@main
struct NBAStatsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                FixturesView().tabItem { Label("Fixtures", systemImage: "sportscourt") }
                StandingsView().tabItem { Label("Standings", systemImage: "list.dash") }
                PreferencesView().tabItem { Label("Preferences", systemImage: "gearshape") }
            }
        }
    }
}
