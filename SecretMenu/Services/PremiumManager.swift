//
//  PremiumManager.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremiumUser: Bool = false
    @Published var freePlaceLimit: Int = 3
    @Published var freeOrderLimit: Int = 5
    @Published var unlockedOrderSlots: Int = 0
    @Published var lastAdUnlockDate: Date?
    
    private let userDefaults = UserDefaults.standard
    private let premiumKey = "isPremiumUser"
    private let unlockedSlotsKey = "unlockedOrderSlots"
    private let lastAdUnlockKey = "lastAdUnlockDate"
    
    private init() {
        loadPremiumStatus()
        loadUnlockedSlots()
    }
    
    // MARK: - Premium Status
    
    var freeOrderLimitReached: Bool {
        // This will be calculated based on actual order count
        return false // Placeholder - will be implemented with actual order count
    }
    
    var freePlaceLimitReached: Bool {
        // This will be calculated based on actual place count
        return false // Placeholder - will be implemented with actual place count
    }
    
    var totalOrderLimit: Int {
        return freeOrderLimit + unlockedOrderSlots
    }
    
    // MARK: - Premium Features
    
    var canAddUnlimitedOrders: Bool {
        return isPremiumUser
    }
    
    var canAddUnlimitedPlaces: Bool {
        return isPremiumUser
    }
    
    var canAddUnlimitedPhotos: Bool {
        return isPremiumUser
    }
    
    var canUseCustomThemes: Bool {
        return isPremiumUser
    }
    
    var canUseCustomTagColors: Bool {
        return isPremiumUser
    }
    
    var canExportOrders: Bool {
        return isPremiumUser
    }
    
    var shouldShowAds: Bool {
        return !isPremiumUser
    }
    
    // MARK: - Ad Unlock System
    
    func canUnlockWithAd() -> Bool {
        guard !isPremiumUser else { return false }
        
        if let lastUnlock = lastAdUnlockDate {
            let calendar = Calendar.current
            return !calendar.isDate(lastUnlock, inSameDayAs: Date())
        }
        return true
    }
    
    func unlockOrderSlotsWithAd() {
        guard canUnlockWithAd() else { return }
        
        unlockedOrderSlots += 2
        lastAdUnlockDate = Date()
        
        saveUnlockedSlots()
        saveLastAdUnlockDate()
    }
    
    // MARK: - StoreKit Integration (Placeholder)
    
    func purchasePremium() async {
        // TODO: Implement StoreKit purchase in Phase 6
        // For now, just simulate premium purchase
        isPremiumUser = true
        savePremiumStatus()
    }
    
    func restorePurchases() async {
        // TODO: Implement StoreKit restore in Phase 6
        // For now, just load saved premium status
        loadPremiumStatus()
    }
    
    // MARK: - Private Methods
    
    private func loadPremiumStatus() {
        isPremiumUser = userDefaults.bool(forKey: premiumKey)
    }
    
    private func savePremiumStatus() {
        userDefaults.set(isPremiumUser, forKey: premiumKey)
    }
    
    private func loadUnlockedSlots() {
        unlockedOrderSlots = userDefaults.integer(forKey: unlockedSlotsKey)
    }
    
    private func saveUnlockedSlots() {
        userDefaults.set(unlockedOrderSlots, forKey: unlockedSlotsKey)
    }
    
    private func loadLastAdUnlockDate() {
        if let dateData = userDefaults.object(forKey: lastAdUnlockKey) as? Date {
            lastAdUnlockDate = dateData
        }
    }
    
    private func saveLastAdUnlockDate() {
        userDefaults.set(lastAdUnlockDate, forKey: lastAdUnlockKey)
    }
} 