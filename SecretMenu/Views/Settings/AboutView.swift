//
//  AboutView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon and Name
                    VStack(spacing: 16) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("SecretMenu")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Your personal vault for custom food & drink orders")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // App Description
                    VStack(spacing: 16) {
                        Text("About SecretMenu")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureDescription(
                                icon: "brain.head.profile",
                                title: "Never Forget Again",
                                description: "Save your complicated Starbucks modifications, Chipotle bowl preferences, and any custom order you love."
                            )
                            
                            FeatureDescription(
                                icon: "building.2",
                                title: "Organize by Place",
                                description: "Each order is saved under the restaurant or café where you use it, making it easy to find exactly what you need."
                            )
                            
                            FeatureDescription(
                                icon: "tag",
                                title: "Smart Tagging",
                                description: "Use tags like 'Iced', 'Spicy', 'Vegan' to organize orders across different places."
                            )
                            
                            FeatureDescription(
                                icon: "iphone",
                                title: "Always Ready",
                                description: "Show your saved orders to baristas and servers with a clean, easy-to-read format."
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // How to Use
                    VStack(spacing: 16) {
                        Text("How to Use")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            StepRow(
                                number: "1",
                                title: "Add Places",
                                description: "Start by adding your favorite restaurants and cafés to the Places tab."
                            )
                            
                            StepRow(
                                number: "2",
                                title: "Create Orders",
                                description: "Tap on a place and add your custom orders with all the details and modifications."
                            )
                            
                            StepRow(
                                number: "3",
                                title: "Organize with Tags",
                                description: "Add tags to categorize your orders and find them easily across different places."
                            )
                            
                            StepRow(
                                number: "4",
                                title: "Show & Order",
                                description: "When ordering, tap 'Show to Barista' for a clean view to display to staff."
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Tips Section
                    VStack(spacing: 16) {
                        Text("Pro Tips")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {

                            
                            TipRow(
                                icon: "tag",
                                title: "Use Tags Wisely",
                                description: "Create tags like 'Breakfast', 'Spicy', 'Iced' to quickly filter your orders."
                            )
                            
                            TipRow(
                                icon: "infinity",
                                title: "Go Premium",
                                description: "Upgrade to Premium for unlimited orders, custom themes, and export features."
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Support Section
                    VStack(spacing: 16) {
                        Text("Support")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            SupportRow(
                                icon: "envelope",
                                title: "Contact Us",
                                action: {
                                    contactSupport()
                                }
                            )
                            
                            SupportRow(
                                icon: "questionmark.circle",
                                title: "Help & FAQ",
                                action: {
                                    showHelp()
                                }
                            )
                            
                            SupportRow(
                                icon: "star",
                                title: "Rate SecretMenu",
                                action: {
                                    rateApp()
                                }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // App Info
                    VStack(spacing: 8) {
                        Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Build \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("© 2025 SecretMenu. All rights reserved.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("About")
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
    
    // MARK: - Actions
    
    private func contactSupport() {
        if let url = URL(string: "mailto:secretmenu.contact@gmail.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showHelp() {
        if let url = URL(string: "https://www.notion.so/SecretMenu-Support-235c344a805080c0a02cec32a80c2c88?source=copy_link") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id6748836992") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Supporting Views

struct FeatureDescription: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct StepRow: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct TipRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct SupportRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AboutView()
} 