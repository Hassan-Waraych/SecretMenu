//
//  SettingsView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var showingUpgradeView = false
    @State private var showingAboutView = false
    @State private var showingPrivacyPolicy = false
    @State private var showingDebugMenu = false
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            List {
                // Premium Section
                Section {
                    if premiumManager.isPremiumUser {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Premium Active")
                                    .font(.headline)
                                Text("Unlimited orders, places, and features")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    } else {
                        Button(action: {
                            showingUpgradeView = true
                        }) {
                            HStack {
                                Image(systemName: "crown")
                                    .foregroundColor(.yellow)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Upgrade to Premium")
                                        .font(.headline)
                                    Text("Unlock unlimited features")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    Text("Premium")
                }
                
                // App Features Section
                Section {
                    // Theme Selection (Premium feature)
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(.blue)
                        Text("Theme")
                        Spacer()
                        if premiumManager.canUseCustomThemes {
                            Picker("Theme", selection: $themeManager.currentTheme) {
                                Text("System").tag(AppTheme.system)
                                Text("Light").tag(AppTheme.light)
                                Text("Dark").tag(AppTheme.dark)
                            }
                            .pickerStyle(MenuPickerStyle())
                        } else {
                            Button(action: {
                                showingUpgradeView = true
                            }) {
                                HStack(spacing: 4) {
                                    Text("Premium")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Image(systemName: "crown")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Restore Purchases
                    Button(action: {
                        Task {
                            await restorePurchases()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.green)
                            Text("Restore Purchases")
                            Spacer()
                            if premiumManager.restoreInProgress {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                    }
                    .disabled(premiumManager.restoreInProgress)
                    
                    // Debug Section (Development Only)
                    #if DEBUG
                    Section {
                        Button(action: {
                            showingDebugMenu = true
                        }) {
                            HStack {
                                Image(systemName: "ladybug")
                                    .foregroundColor(.orange)
                                Text("Debug Menu")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                    } header: {
                        Text("Development")
                    }
                    #endif
                } header: {
                    Text("Features")
                }
                
                
                // Support Section
                Section {
                    Button(action: {
                        showingAboutView = true
                    }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("About SecretMenu")
                        }
                    }
                    
                    Button(action: {
                        showingPrivacyPolicy = true
                    }) {
                        HStack {
                            Image(systemName: "hand.raised")
                                .foregroundColor(.blue)
                            Text("Privacy Policy")
                        }
                    }
                    
                    Button(action: {
                        rateApp()
                    }) {
                        HStack {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                            Text("Rate SecretMenu")
                        }
                    }
                    
                    Button(action: {
                        shareApp()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.green)
                            Text("Share SecretMenu")
                        }
                    }
                } header: {
                    Text("Support")
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("App Info")
                }
                
                // Debug Section (Development Only)
                #if DEBUG
                Section {
                    Button(action: {
                        showingDebugMenu = true
                    }) {
                        HStack {
                            Image(systemName: "ladybug")
                                .foregroundColor(.orange)
                            Text("Debug Menu")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Development")
                }
                #endif
            }
            .navigationTitle("Settings")
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
        }
    }
    
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
} 