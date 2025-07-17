//
//  PrivacyPolicyView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last updated: January 2025")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Introduction
                    PolicySection(
                        title: "Introduction",
                        content: """
                        SecretMenu ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application SecretMenu (the "App").
                        
                        By using our App, you agree to the collection and use of information in accordance with this policy.
                        """
                    )
                    
                    // Information We Collect
                    PolicySection(
                        title: "Information We Collect",
                        content: """
                        **Local Data Storage**: SecretMenu stores all your data locally on your device. We do not collect, store, or transmit any personal information to our servers.
                        
                        **Data You Create**: The App allows you to create and store:
                        • Custom food and drink orders
                        • Restaurant and café names
                        • Tags and categories
                        • Photos of your orders (optional)
                        
                        **Device Information**: We may collect basic device information for app functionality and crash reporting, but this does not include personal data.
                        """
                    )
                    
                    // How We Use Information
                    PolicySection(
                        title: "How We Use Information",
                        content: """
                        **Local Functionality**: All data you create in SecretMenu is used solely to provide the app's core functionality:
                        • Display your saved orders
                        • Organize orders by place and tags
                        • Enable the "Show to Barista" feature
                        • Provide search and filtering capabilities
                        
                        **No External Processing**: We do not analyze, sell, or share your data with third parties.
                        """
                    )
                    
                    // Data Storage and Security
                    PolicySection(
                        title: "Data Storage and Security",
                        content: """
                        **Local Storage**: All your data is stored locally on your device using iOS Core Data. This means:
                        • Your data never leaves your device
                        • We cannot access your personal information
                        • Data is protected by your device's security measures
                        
                        **Backup**: If you have iCloud backup enabled, your app data may be included in your device backup, subject to Apple's privacy policies.
                        """
                    )
                    
                    // Third-Party Services
                    PolicySection(
                        title: "Third-Party Services",
                        content: """
                        **Apple Services**: Our App integrates with Apple services:
                        • App Store for purchases and app updates
                        • StoreKit for in-app purchases
                        • iCloud for device backups (if enabled)
                        
                        **Analytics**: We may use anonymous analytics to improve app performance, but this does not include personal data.
                        """
                    )
                    
                    // In-App Purchases
                    PolicySection(
                        title: "In-App Purchases",
                        content: """
                        **Premium Features**: SecretMenu offers premium features through in-app purchases:
                        • Purchase information is handled by Apple's StoreKit
                        • We do not store payment information
                        • Purchase history is managed by Apple
                        
                        **Restore Purchases**: You can restore previous purchases through the App Store, subject to Apple's terms.
                        """
                    )
                    
                    // Children's Privacy
                    PolicySection(
                        title: "Children's Privacy",
                        content: """
                        SecretMenu does not knowingly collect personal information from children under 13. The App is designed for general audiences and does not require personal information to function.
                        
                        If you are a parent or guardian and believe your child has provided us with personal information, please contact us.
                        """
                    )
                    
                    // Data Deletion
                    PolicySection(
                        title: "Data Deletion",
                        content: """
                        **Local Deletion**: You can delete your data at any time by:
                        • Deleting individual orders or places within the app
                        • Uninstalling the app (this removes all local data)
                        
                        **No Server Data**: Since we don't store your data on our servers, there's no need for us to delete data from external systems.
                        """
                    )
                    
                    // Changes to Privacy Policy
                    PolicySection(
                        title: "Changes to This Privacy Policy",
                        content: """
                        We may update our Privacy Policy from time to time. We will notify you of any changes by:
                        • Posting the new Privacy Policy in the App
                        • Updating the "Last updated" date
                        
                        You are advised to review this Privacy Policy periodically for any changes.
                        """
                    )
                    
                    // Contact Information
                    PolicySection(
                        title: "Contact Us",
                        content: """
                        If you have any questions about this Privacy Policy, please contact us:
                        
                        **Email**: privacy@secretmenu.app
                        **App**: Through the Settings > About section
                        
                        We will respond to your inquiry within a reasonable timeframe.
                        """
                    )
                    
                    // Legal Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Legal Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("This Privacy Policy is governed by and construed in accordance with applicable privacy laws. If any provision of this policy is found to be invalid, the remaining provisions will continue to be valid and enforceable.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Privacy Policy")
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

// MARK: - Supporting Views

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    PrivacyPolicyView()
} 