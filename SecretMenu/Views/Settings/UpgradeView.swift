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
    
    // Animation states
    @State private var animateHeader = false
    @State private var animateFeatures = false
    @State private var animateLimits = false
    @State private var animatePricing = false
    @State private var animateButton = false
    @State private var crownRotation: Double = 0
    @State private var crownScale: CGFloat = 1.0
    @State private var buttonScale: CGFloat = 1.0
    @State private var buttonOpacity: Double = 1.0
    @State private var featureOffset: CGFloat = 50
    @State private var featureOpacity: Double = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.5),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Section
                        headerSection
                            .offset(y: animateHeader ? 0 : -50)
                            .opacity(animateHeader ? 1 : 0)
                        
                        // Feature Comparison
                        featuresSection
                            .offset(y: animateFeatures ? 0 : 50)
                            .opacity(animateFeatures ? 1 : 0)
                        
                        // Current Limits (Free Users)
                        if !premiumManager.isPremiumUser {
                            limitsSection
                                .offset(y: animateLimits ? 0 : 50)
                                .opacity(animateLimits ? 1 : 0)
                        }
                        
                        // Pricing Section
                        pricingSection
                            .offset(y: animatePricing ? 0 : 50)
                            .opacity(animatePricing ? 1 : 0)
                        
                        // Terms and Privacy
                        termsSection
                            .offset(y: animatePricing ? 0 : 50)
                            .opacity(animatePricing ? 1 : 0)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
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
            .onAppear {
                startAnimations()
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Animated crown
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(crownScale)
                
                // Crown icon
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(crownRotation))
                    .scaleEffect(crownScale)
            }
            
            VStack(spacing: 12) {
                Text("Upgrade to Premium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Unlock unlimited features and remove all restrictions")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("What You'll Get")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 16) {
                FeatureRow(
                    icon: "infinity",
                    title: "Unlimited Orders",
                    description: "Save as many custom orders as you want",
                    isPremium: true,
                    gradient: [.blue, .cyan]
                )
                
                FeatureRow(
                    icon: "building.2",
                    title: "Unlimited Places",
                    description: "Add unlimited custom restaurants and cafes",
                    isPremium: true,
                    gradient: [.green, .mint]
                )
                
                FeatureRow(
                    icon: "paintbrush",
                    title: "Custom Themes",
                    description: "Choose from light, dark, or system themes",
                    isPremium: true,
                    gradient: [.purple, .indigo]
                )
                
                FeatureRow(
                    icon: "tag",
                    title: "Premium Tag Colors",
                    description: "Customize tag colors and styles",
                    isPremium: true,
                    gradient: [.orange, .red]
                )
                
                FeatureRow(
                    icon: "xmark.circle",
                    title: "No Ads",
                    description: "Remove all banner and rewarded ads",
                    isPremium: true,
                    gradient: [.gray, .secondary]
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
    }
    
    // MARK: - Limits Section
    
    private var limitsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Current Free Limits")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                LimitRow(
                    icon: "list.bullet",
                    text: "\(premiumManager.freeOrderLimit) Orders",
                    isLimit: true,
                    gradient: [.red, .pink]
                )
                
                LimitRow(
                    icon: "building.2",
                    text: "\(premiumManager.freePlaceLimit) Custom Places",
                    isLimit: true,
                    gradient: [.orange, .yellow]
                )
                
                LimitRow(
                    icon: "play.rectangle",
                    text: "Banner & Rewarded Ads",
                    isLimit: true,
                    gradient: [.gray, .secondary]
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.orange.opacity(0.5), .red.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    // MARK: - Pricing Section
    
    private var pricingSection: some View {
        VStack(spacing: 24) {
            // Price display
            VStack(spacing: 12) {
                if let premiumProduct = premiumManager.products.first {
                    VStack(spacing: 8) {
                        Text(premiumProduct.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(premiumProduct.displayPrice)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("One-time purchase")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(spacing: 8) {
                        Text("Premium")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("$3.99")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("One-time purchase")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            
            // Purchase Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    buttonScale = 0.95
                    buttonOpacity = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonScale = 1.0
                        buttonOpacity = 1.0
                    }
                    Task {
                        await purchasePremium()
                    }
                }
            }) {
                HStack(spacing: 12) {
                    if premiumManager.purchaseInProgress {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                        Text("Upgrade Now")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .disabled(premiumManager.purchaseInProgress)
            .scaleEffect(buttonScale)
            .opacity(buttonOpacity)
            
            // Restore Purchases
            Button(action: {
                Task {
                    await restorePurchases()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.body)
                    Text("Restore Purchases")
                        .font(.body)
                        .fontWeight(.medium)
                }
                .foregroundColor(.blue)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                )
            }
            .disabled(premiumManager.restoreInProgress)
        }
    }
    
    // MARK: - Terms Section
    
    private var termsSection: some View {
        VStack(spacing: 12) {
            Text("By purchasing, you agree to our Terms of Service and Privacy Policy")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 24) {
                Button("Terms") {
                    showingTermsView = true
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                )
                
                Button("Privacy") {
                    showingPrivacyPolicyView = true
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.1))
                )
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Animation Methods
    
    private func startAnimations() {
        // Header animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
            animateHeader = true
        }
        
        // Crown animation
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            crownScale = 1.1
        }
        
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            crownRotation = 360
        }
        
        // Features animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
            animateFeatures = true
        }
        
        // Limits animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5)) {
            animateLimits = true
        }
        
        // Pricing animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.7)) {
            animatePricing = true
        }
        
        // Feature row animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                featureOffset = 0
                featureOpacity = 1
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
    let gradient: [Color]
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isPremium {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isHovered ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .scaleEffect(isHovered ? 1.02 : 1.0)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isHovered = false
                }
            }
        }
    }
}

struct LimitRow: View {
    let icon: String
    let text: String
    let isLimit: Bool
    let gradient: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isLimit {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
        )
    }
}

#Preview {
    UpgradeView()
        .environmentObject(PremiumManager.shared)
} 