//
//  AdManager.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation
import SwiftUI

@MainActor
class AdManager: ObservableObject {
    static let shared = AdManager()
    
    @Published var isBannerAdLoaded = false
    @Published var isRewardedAdLoaded = false
    
    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Test ID
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313" // Test ID
    
    private init() {
        setupAdMob()
    }
    
    // MARK: - Setup
    
    private func setupAdMob() {
        // TODO: Initialize Google Mobile Ads SDK in Phase 7
        // GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Load initial ads
        loadBannerAd()
        loadRewardedAd()
    }
    
    // MARK: - Banner Ads
    
    func loadBannerAd() {
        // TODO: Implement actual banner ad loading in Phase 7
        print("Banner ad loading placeholder")
        isBannerAdLoaded = false // Set to false for now
    }
    
    // MARK: - Rewarded Ads
    
    func loadRewardedAd() {
        // TODO: Implement actual rewarded ad loading in Phase 7
        print("Rewarded ad loading placeholder")
        isRewardedAdLoaded = false // Set to false for now
    }
    
    func showRewardedAd(completion: @escaping (Bool) -> Void) {
        // TODO: Implement actual rewarded ad display in Phase 7
        print("Rewarded ad display placeholder")
        completion(false) // Simulate failure for now
    }
    
    func unlockOrderSlots() {
        // This method is called when user completes a rewarded ad
        // It should increment the order limit in PremiumManager
        PremiumManager.shared.unlockOrderSlots()
    }
    
    // MARK: - Ad Status
    
    func shouldShowAds() -> Bool {
        return !PremiumManager.shared.isPremiumUser
    }
}

// MARK: - SwiftUI Banner Ad View (Placeholder)

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = "Ad Banner Placeholder"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
} 