//
//  DebugMenuView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

struct DebugMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var premiumManager: PremiumManager
    @StateObject private var dataStore = DataStore.shared
    
    @State private var showingResetAlert = false
    @State private var showingPurchaseTest = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Premium Status Section
                        premiumStatusSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                        
                        // Purchase Testing Section
                        purchaseTestingSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 40)
                        
                        // Data Management Section
                        dataManagementSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 50)
                        
                        // Limits Testing Section
                        limitsTestingSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 60)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Debug Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    animateIn = true
                }
            }
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will delete all places, orders, and tags. This action cannot be undone.")
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Premium Status Section
    
    private var premiumStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Premium Status", icon: "crown.fill")
            
            VStack(spacing: 12) {
                statusRow(
                    title: "Premium User",
                    value: premiumManager.isPremiumUser ? "Yes" : "No",
                    color: premiumManager.isPremiumUser ? .green : .red
                )
                
                statusRow(
                    title: "Free Place Limit",
                    value: "\(premiumManager.freePlaceLimit)",
                    color: .blue
                )
                
                statusRow(
                    title: "Free Order Limit",
                    value: "\(premiumManager.freeOrderLimit)",
                    color: .blue
                )
                
                statusRow(
                    title: "Unlocked Order Slots",
                    value: "\(premiumManager.unlockedOrderSlots)",
                    color: .orange
                )
                
                if let lastUnlock = premiumManager.lastAdUnlockDate {
                    statusRow(
                        title: "Last Ad Unlock",
                        value: formatDate(lastUnlock),
                        color: .purple
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Purchase Testing Section
    
    private var purchaseTestingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Purchase Testing", icon: "cart.fill")
            
            VStack(spacing: 12) {
                Button(action: testPurchase) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Test Premium Purchase")
                        Spacer()
                        if premiumManager.purchaseInProgress {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                }
                .disabled(premiumManager.purchaseInProgress)
                
                Button(action: testRestore) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Test Restore Purchases")
                        Spacer()
                        if premiumManager.restoreInProgress {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                    )
                }
                .disabled(premiumManager.restoreInProgress)
                
                Button(action: togglePremiumStatus) {
                    HStack {
                        Image(systemName: premiumManager.isPremiumUser ? "crown.slash" : "crown.fill")
                        Text(premiumManager.isPremiumUser ? "Remove Premium" : "Grant Premium")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(premiumManager.isPremiumUser ? Color.red : Color.orange)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Data Management Section
    
    private var dataManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Data Management", icon: "database.fill")
            
            VStack(spacing: 12) {
                Button(action: { showingResetAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Reset All Data")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red)
                    )
                }
                
                Button(action: addTestData) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Test Data")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                    )
                }
                
                Button(action: exportData) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Data (Premium)")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(premiumManager.canExportOrders ? Color.blue : Color.gray)
                    )
                }
                .disabled(!premiumManager.canExportOrders)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Limits Testing Section
    
    private var limitsTestingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Limits Testing", icon: "chart.bar.fill")
            
            VStack(spacing: 12) {
                let orderCount = getOrderCount()
                let placeCount = getPlaceCount()
                
                statusRow(
                    title: "Current Orders",
                    value: "\(orderCount)",
                    color: orderCount >= premiumManager.totalOrderLimit ? .red : .green
                )
                
                statusRow(
                    title: "Current Places",
                    value: "\(placeCount)",
                    color: placeCount >= premiumManager.freePlaceLimit ? .red : .green
                )
                
                statusRow(
                    title: "Can Add Orders",
                    value: premiumManager.canAddUnlimitedOrders ? "Unlimited" : "Limited",
                    color: premiumManager.canAddUnlimitedOrders ? .green : .orange
                )
                
                statusRow(
                    title: "Can Add Places",
                    value: premiumManager.canAddUnlimitedPlaces ? "Unlimited" : "Limited",
                    color: premiumManager.canAddUnlimitedPlaces ? .green : .orange
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Helper Methods
    
    private func statusRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func getOrderCount() -> Int {
        do {
            return try DataStore.shared.getOrderCount()
        } catch {
            return 0
        }
    }
    
    private func getPlaceCount() -> Int {
        do {
            return try DataStore.shared.getTotalPlacesCount()
        } catch {
            return 0
        }
    }
    
    // MARK: - Actions
    
    private func testPurchase() {
        Task {
            let success = await premiumManager.purchasePremium()
            if success {
                print("Premium purchase test successful")
            } else {
                errorMessage = "Premium purchase test failed"
                showingError = true
            }
        }
    }
    
    private func testRestore() {
        Task {
            let success = await premiumManager.restorePurchases()
            if success {
                print("Restore purchases test successful")
            } else {
                errorMessage = "Restore purchases test failed"
                showingError = true
            }
        }
    }
    
    private func togglePremiumStatus() {
        premiumManager.isPremiumUser.toggle()
        premiumManager.savePremiumStatus()
    }
    
    private func resetAllData() {
        do {
            // Delete all orders
            let orders = try DataStore.shared.fetchOrders()
            for order in orders {
                try DataStore.shared.deleteOrder(order)
            }
            
            // Delete all places
            let places = try DataStore.shared.fetchPlaces()
            for place in places {
                try DataStore.shared.deletePlace(place)
            }
            
            // Delete all tags
            let tags = try DataStore.shared.fetchTags()
            for tag in tags {
                try DataStore.shared.deleteTag(tag)
            }
            
            print("All data reset successfully")
        } catch {
            errorMessage = "Failed to reset data: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func addTestData() {
        do {
            // Add test places
            let place1 = try DataStore.shared.createPlace(name: "Test Coffee Shop")
            let place2 = try DataStore.shared.createPlace(name: "Test Restaurant")
            
            if case .success(let coffeeShop) = place1,
               case .success(let restaurant) = place2 {
                
                // Add test orders
                let _ = try DataStore.shared.createOrder(
                    title: "Test Latte",
                    details: "Extra shot, oat milk, light ice",
                    place: coffeeShop,
                    tags: ["Coffee", "Test"]
                )
                
                let _ = try DataStore.shared.createOrder(
                    title: "Test Burger",
                    details: "Medium rare, extra cheese, no onions",
                    place: restaurant,
                    tags: ["Food", "Test"]
                )
            }
            
            print("Test data added successfully")
        } catch {
            errorMessage = "Failed to add test data: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func exportData() {
        // TODO: Implement data export functionality
        print("Export data functionality to be implemented")
    }
}



#Preview {
    DebugMenuView()
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
        .environmentObject(PremiumManager.shared)
} 