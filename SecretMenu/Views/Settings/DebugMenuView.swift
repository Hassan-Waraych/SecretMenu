//
//  DebugMenuView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

struct DebugMenuView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @EnvironmentObject var adManager: AdManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundColor(.yellow)
                        Text("Premium Status")
                        Spacer()
                        Toggle("", isOn: $premiumManager.isPremiumUser)
                            .onChange(of: premiumManager.isPremiumUser) { newValue in
                                // Save the change
                                premiumManager.savePremiumStatus()
                            }
                    }
                    
                    HStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.blue)
                        Text("Unlocked Order Slots")
                        Spacer()
                        Text("\(premiumManager.unlockedOrderSlots)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        premiumManager.unlockedOrderSlots += 1
                        premiumManager.saveUnlockedSlots()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                            Text("Add 1 Order Slot")
                        }
                    }
                    
                    Button(action: {
                        premiumManager.unlockedOrderSlots = 0
                        premiumManager.saveUnlockedSlots()
                    }) {
                        HStack {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                            Text("Reset Order Slots")
                        }
                    }
                } header: {
                    Text("Premium & Limits")
                }
                
                Section {
                    HStack {
                        Text("Banner Ad Status")
                        Spacer()
                        Text(adManager.isBannerAdLoaded ? "Loaded" : "Not Loaded")
                            .foregroundColor(adManager.isBannerAdLoaded ? .green : .red)
                    }
                    
                    HStack {
                        Text("Rewarded Ad Status")
                        Spacer()
                        Text(adManager.isRewardedAdLoaded ? "Loaded" : "Not Loaded")
                            .foregroundColor(adManager.isRewardedAdLoaded ? .green : .red)
                    }
                    
                    HStack {
                        Text("Can Unlock with Ad")
                        Spacer()
                        Text(adManager.canShowRewardedAd() ? "Yes" : "No")
                            .foregroundColor(adManager.canShowRewardedAd() ? .green : .red)
                    }
                    
                    HStack {
                        Text("Unlocked Slots")
                        Spacer()
                        Text("\(premiumManager.unlockedOrderSlots)")
                            .foregroundColor(.secondary)
                    }
                    
                    if premiumManager.lastAdUnlockDate != nil {
                        HStack {
                            Text("Last Ad Unlock")
                            Spacer()
                            Text(premiumManager.lastAdUnlockDate?.formatted(date: .abbreviated, time: .shortened) ?? "Never")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        adManager.loadRewardedAd()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.blue)
                            Text("Reload Rewarded Ad")
                        }
                    }
                    
                    Button(action: {
                        adManager.forceRefreshAds()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .foregroundColor(.orange)
                            Text("Force Refresh All Ads")
                        }
                    }
                    
                    Button(action: {
                        premiumManager.lastAdUnlockDate = nil
                        premiumManager.saveLastAdUnlockDate()
                    }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.orange)
                            Text("Reset Ad Unlock Date")
                        }
                    }
                } header: {
                    Text("Ad Status")
                }
                
                Section {
                    Button(action: {
                        // Clear all UserDefaults
                        if let bundleID = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        }
                        // Reload premium status
                        premiumManager.loadPremiumStatus()
                        premiumManager.loadUnlockedSlots()
                        premiumManager.loadLastAdUnlockDate()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear All UserDefaults")
                        }
                    }
                    
                    Button(action: {
                        // Reset Core Data
                        let placeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
                        let orderRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
                        let tagRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
                        
                        let placeDeleteRequest = NSBatchDeleteRequest(fetchRequest: placeRequest)
                        let orderDeleteRequest = NSBatchDeleteRequest(fetchRequest: orderRequest)
                        let tagDeleteRequest = NSBatchDeleteRequest(fetchRequest: tagRequest)
                        
                        try? DataStore.shared.viewContext.execute(placeDeleteRequest)
                        try? DataStore.shared.viewContext.execute(orderDeleteRequest)
                        try? DataStore.shared.viewContext.execute(tagDeleteRequest)
                        try? DataStore.shared.save()
                    }) {
                        HStack {
                            Image(systemName: "database")
                                .foregroundColor(.red)
                            Text("Clear All Data")
                        }
                    }
                } header: {
                    Text("Data Management")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Status")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Premium: \(premiumManager.isPremiumUser ? "Yes" : "No")")
                                .font(.caption)
                            Text("Order Slots: \(premiumManager.unlockedOrderSlots)")
                                .font(.caption)
                            Text("Can Unlock with Ad: \(premiumManager.canUnlockWithAd() ? "Yes" : "No")")
                                .font(.caption)
                            Text("Free Order Limit: \(premiumManager.freeOrderLimit)")
                                .font(.caption)
                            Text("Total Order Limit: \(premiumManager.totalOrderLimit)")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Debug Info")
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DebugMenuView()
        .environmentObject(PremiumManager.shared)
} 