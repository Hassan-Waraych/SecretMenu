//
//  UpgradeView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import StoreKit

struct UpgradeView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingPurchaseError = false
    @State private var purchaseErrorMessage = ""
    @State private var showingTermsView = false
    @State private var showingPrivacyPolicyView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Upgrade to Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Unlock unlimited features and remove all restrictions")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Feature Comparison
                    VStack(spacing: 16) {
                        Text("What You'll Get")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            FeatureRow(
                                icon: "infinity",
                                title: "Unlimited Orders",
                                description: "Save as many custom orders as you want",
                                isPremium: true
                            )
                            
                            FeatureRow(
                                icon: "building.2",
                                title: "Unlimited Places",
                                description: "Add unlimited custom restaurants and cafes",
                                isPremium: true
                            )
                            
                            FeatureRow(
                                icon: "photo",
                                title: "Unlimited Photos",
                                description: "Add multiple photos to each order",
                                isPremium: true
                            )
                            
                            FeatureRow(
                                icon: "paintbrush",
                                title: "Custom Themes",
                                description: "Choose from light, dark, or system themes",
                                isPremium: true
                            )
                            
                            FeatureRow(
                                icon: "tag",
                                title: "Premium Tag Colors",
                                description: "Customize tag colors and styles",
                                isPremium: true
                            )
                            
                            FeatureRow(
                                icon: "xmark.circle",
                                title: "No Ads",
                                description: "Remove all banner and rewarded ads",
                                isPremium: true
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Current Limits (Free Users)
                    if !premiumManager.isPremiumUser {
                        VStack(spacing: 12) {
                            Text("Current Free Limits")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                LimitRow(
                                    icon: "list.bullet",
                                    text: "\(premiumManager.freeOrderLimit) Orders",
                                    isLimit: true
                                )
                                
                                LimitRow(
                                    icon: "building.2",
                                    text: "\(premiumManager.freePlaceLimit) Custom Places",
                                    isLimit: true
                                )
                                
                                LimitRow(
                                    icon: "photo",
                                    text: "1 Photo per Order",
                                    isLimit: true
                                )
                                
                                LimitRow(
                                    icon: "play.rectangle",
                                    text: "Banner & Rewarded Ads",
                                    isLimit: true
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Pricing Section
                    VStack(spacing: 16) {
                        if let premiumProduct = premiumManager.products.first {
                            VStack(spacing: 8) {
                                Text(premiumProduct.displayName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(premiumProduct.displayPrice)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                Text("One-time purchase")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            VStack(spacing: 8) {
                                Text("Premium")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("$3.99")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                Text("One-time purchase")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Purchase Button
                        Button(action: {
                            Task {
                                await purchasePremium()
                            }
                        }) {
                            HStack {
                                if premiumManager.purchaseInProgress {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Upgrade Now")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(premiumManager.purchaseInProgress)
                        .padding(.horizontal)
                        
                        // Restore Purchases
                        Button(action: {
                            Task {
                                await restorePurchases()
                            }
                        }) {
                            Text("Restore Purchases")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        .disabled(premiumManager.restoreInProgress)
                    }
                    
                    // Terms and Privacy
                    VStack(spacing: 8) {
                        Text("By purchasing, you agree to our Terms of Service and Privacy Policy")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            Button("Terms") {
                                showingTermsView = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                            
                            Button("Privacy") {
                                showingPrivacyPolicyView = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Purchase Error", isPresented: $showingPurchaseError) {
                Button("OK") { }
            } message: {
                Text(purchaseErrorMessage)
            }
            .sheet(isPresented: $showingTermsView) {
                TermsView()
            }
            .sheet(isPresented: $showingPrivacyPolicyView) {
                PrivacyPolicyView()
            }
        }
    }
    
    // MARK: - Actions
    
    private func purchasePremium() async {
        let success = await premiumManager.purchasePremium()
        if success {
            dismiss()
        } else {
            purchaseErrorMessage = "Purchase failed. Please try again."
            showingPurchaseError = true
        }
    }
    
    private func restorePurchases() async {
        let success = await premiumManager.restorePurchases()
        if success {
            dismiss()
        } else {
            purchaseErrorMessage = "No purchases found to restore."
            showingPurchaseError = true
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let isPremium: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isPremium ? .yellow : .gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isPremium {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LimitRow: View {
    let icon: String
    let text: String
    let isLimit: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if isLimit {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    UpgradeView()
        .environmentObject(PremiumManager.shared)
} 