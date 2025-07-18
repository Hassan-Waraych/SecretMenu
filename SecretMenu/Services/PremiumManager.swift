//
//  PremiumManager.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    // MARK: - Product Identifiers
    private let premiumProductId = "com.secretmenu.premium"
    
    // MARK: - Published Properties
    @Published var isPremiumUser: Bool = false
    @Published var freePlaceLimit: Int = 3
    @Published var freeOrderLimit: Int = 5
    @Published var unlockedOrderSlots: Int = 0
    @Published var lastAdUnlockDate: Date?
    @Published var products: [Product] = []
    @Published var purchaseInProgress: Bool = false
    @Published var restoreInProgress: Bool = false
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let premiumKey = "isPremiumUser"
    private let unlockedSlotsKey = "unlockedOrderSlots"
    private let lastAdUnlockKey = "lastAdUnlockDate"
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        loadPremiumStatus()
        loadUnlockedSlots()
        loadLastAdUnlockDate()
        
        // Start listening for transactions
        updateListenerTask = listenForTransactions()
        
        // Load products
        Task {
            await loadProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
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
    
    var canUnlockMoreOrders: Bool {
        return canUnlockWithAd()
    }
    
    func canUnlockWithAd() -> Bool {
        guard !isPremiumUser else { return false }
        
        if let lastUnlock = lastAdUnlockDate {
            let calendar = Calendar.current
            return !calendar.isDate(lastUnlock, inSameDayAs: Date())
        }
        return true
    }
    
    func unlockOrderSlots() {
        guard canUnlockWithAd() else { return }
        
        unlockedOrderSlots += 1
        lastAdUnlockDate = Date()
        
        saveUnlockedSlots()
        saveLastAdUnlockDate()
    }
    
    func unlockOrderSlotsWithAd() {
        guard canUnlockWithAd() else { return }
        
        unlockedOrderSlots += 1
        lastAdUnlockDate = Date()
        
        saveUnlockedSlots()
        saveLastAdUnlockDate()
    }
    
    // MARK: - StoreKit Integration
    
    func loadProducts() async {
        do {
            let productIds = Set([premiumProductId])
            products = try await Product.products(for: productIds)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchasePremium() async -> Bool {
        guard let product = products.first(where: { $0.id == premiumProductId }) else {
            print("Premium product not found")
            return false
        }
        
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Check whether the transaction is verified
                switch verification {
                case .verified(let transaction):
                    // Deliver content to the user
                    await deliverPurchase(transaction)
                    return true
                case .unverified:
                    // Transaction failed verification
                    print("Transaction failed verification")
                    return false
                }
            case .userCancelled:
                print("User cancelled purchase")
                return false
            case .pending:
                print("Purchase pending")
                return false
            @unknown default:
                print("Unknown purchase result")
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }
    
    func restorePurchases() async -> Bool {
        restoreInProgress = true
        defer { restoreInProgress = false }
        
        do {
            try await AppStore.sync()
            return true
        } catch {
            print("Failed to restore purchases: \(error)")
            return false
        }
    }
    
    private func deliverPurchase(_ transaction: Transaction) async {
        // Verify the transaction is for our premium product
        guard transaction.productID == premiumProductId else { return }
        
        // Update premium status
        isPremiumUser = true
        savePremiumStatus()
        
        // Finish the transaction
        await transaction.finish()
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handleTransactionResult(result)
            }
        }
    }
    
    private func handleTransactionResult(_ result: VerificationResult<Transaction>) async {
        switch result {
        case .verified(let transaction):
            await deliverPurchase(transaction)
        case .unverified:
            print("Transaction failed verification")
        }
    }
    
    // MARK: - Private Methods
    
    func loadPremiumStatus() {
        isPremiumUser = userDefaults.bool(forKey: premiumKey)
    }
    
    func savePremiumStatus() {
        userDefaults.set(isPremiumUser, forKey: premiumKey)
    }
    
    func loadUnlockedSlots() {
        unlockedOrderSlots = userDefaults.integer(forKey: unlockedSlotsKey)
    }
    
    func saveUnlockedSlots() {
        userDefaults.set(unlockedOrderSlots, forKey: unlockedSlotsKey)
    }
    
    func loadLastAdUnlockDate() {
        if let dateData = userDefaults.object(forKey: lastAdUnlockKey) as? Date {
            lastAdUnlockDate = dateData
        }
    }
    
    func saveLastAdUnlockDate() {
        userDefaults.set(lastAdUnlockDate, forKey: lastAdUnlockKey)
    }
} 