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
                        premiumManager.unlockedOrderSlots += 2
                        premiumManager.saveUnlockedSlots()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                            Text("Add 2 Order Slots")
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
                        Image(systemName: "calendar")
                            .foregroundColor(.purple)
                        Text("Last Ad Unlock Date")
                        Spacer()
                        if let lastUnlock = premiumManager.lastAdUnlockDate {
                            Text(lastUnlock.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Never")
                                .font(.caption)
                                .foregroundColor(.secondary)
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
                    Text("Ad System")
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