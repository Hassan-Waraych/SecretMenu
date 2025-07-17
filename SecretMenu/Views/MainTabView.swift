//
//  MainTabView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var adManager = AdManager.shared
    
    var body: some View {
        TabView {
            PlacesListView()
                .tabItem {
                    Label("Places", systemImage: "building.2")
                }
            
            TagsListView()
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(premiumManager)
        .environmentObject(adManager)
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
} 