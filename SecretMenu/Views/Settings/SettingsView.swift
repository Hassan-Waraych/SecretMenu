//
//  SettingsView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @EnvironmentObject var adManager: AdManager
    @State private var showingUpgradeView = false
    @State private var showingAboutView = false
    @State private var showingPrivacyPolicy = false
    @State private var showingDebugMenu = false
    @StateObject private var themeManager = ThemeManager.shared
    
    // Animation states
    @State private var animatePremiumCard = false
    @State private var animateFeatures = false
    @State private var animateSupport = false
    @State private var animateAppInfo = false
    @State private var buttonScale: CGFloat = 1.0
    
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
                        // Premium Section
                        premiumSection
                            .offset(y: animatePremiumCard ? 0 : 50)
                            .opacity(animatePremiumCard ? 1 : 0)
                        
                        // Features Section
                        featuresSection
                            .offset(y: animateFeatures ? 0 : 50)
                            .opacity(animateFeatures ? 1 : 0)
                        
                        // Support Section
                        supportSection
                            .offset(y: animateSupport ? 0 : 50)
                            .opacity(animateSupport ? 1 : 0)
                        
                        // App Info Section
                        appInfoSection
                            .offset(y: animateAppInfo ? 0 : 50)
                            .opacity(animateAppInfo ? 1 : 0)
                        
                        // Debug Section (Development Only)
                        #if DEBUG
                        debugSection
                            .offset(y: animateAppInfo ? 0 : 50)
                            .opacity(animateAppInfo ? 1 : 0)
                        #endif
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingUpgradeView) {
                UpgradeView()
            }
            .sheet(isPresented: $showingAboutView) {
                AboutView()
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingDebugMenu) {
                DebugMenuView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animatePremiumCard = true
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateFeatures = true
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                    animateSupport = true
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                    animateAppInfo = true
                }
            }
        }
    }
    
    // MARK: - Premium Section
    
    private var premiumSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "crown.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Premium")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            if premiumManager.isPremiumUser {
                premiumActiveCard
            } else {
                upgradeCard
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var premiumActiveCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "checkmark")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Premium Active")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Unlimited orders, places, and features")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var upgradeCard: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    buttonScale = 1.0
                }
                showingUpgradeView = true
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "crown")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text("Unlock unlimited features")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(buttonScale)
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Features")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Theme Selection
                themeRow
                
                // Restore Purchases
                restorePurchasesRow
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var themeRow: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "paintbrush")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            Text("Theme")
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            if premiumManager.canUseCustomThemes {
                Picker("", selection: $themeManager.currentTheme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.blue)
            } else {
                Button(action: {
                    showingUpgradeView = true
                }) {
                    HStack(spacing: 4) {
                        Text("Premium")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Image(systemName: "crown")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
    
    private var restorePurchasesRow: some View {
        Button(action: {
            Task {
                await restorePurchases()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text("Restore Purchases")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if premiumManager.restoreInProgress {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(premiumManager.restoreInProgress)
    }
    
    // MARK: - Support Section
    
    private var supportSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Support")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                supportRow(
                    icon: "info.circle",
                    title: "About SecretMenu",
                    gradient: [.blue, .cyan],
                    action: { showingAboutView = true }
                )
                
                supportRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    gradient: [.purple, .indigo],
                    action: { showingPrivacyPolicy = true }
                )
                
                supportRow(
                    icon: "star",
                    title: "Rate SecretMenu",
                    gradient: [.yellow, .orange],
                    action: rateApp
                )
                
                supportRow(
                    icon: "square.and.arrow.up",
                    title: "Share SecretMenu",
                    gradient: [.green, .mint],
                    action: shareApp
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func supportRow(icon: String, title: String, gradient: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - App Info Section
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "app.badge")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gray, .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("App Info")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                infoRow(
                    title: "Version",
                    value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
                )
                
                infoRow(
                    title: "Build",
                    value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "info.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Debug Section
    
    #if DEBUG
    private var debugSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "ladybug")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Development")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            supportRow(
                icon: "ladybug",
                title: "Debug Menu",
                gradient: [.orange, .red],
                action: { showingDebugMenu = true }
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    #endif
    
    // MARK: - Helper Methods
    
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
    
    private func restorePurchases() async {
        let success = await premiumManager.restorePurchases()
        if success {
            // Show success message
        } else {
            // Show error message
        }
    }
    
    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id1234567890") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let appUrl = "https://apps.apple.com/app/id1234567890"
        let text = "Check out SecretMenu - Your personal vault for custom food & drink orders! \(appUrl)"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(PremiumManager.shared)
        .environmentObject(AdManager.shared)
} 