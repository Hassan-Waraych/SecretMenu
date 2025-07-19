//
//  TermsView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terms of Service")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last updated: January 2025")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Introduction
                    TermsSection(
                        title: "1. Acceptance of Terms",
                        content: """
                        By downloading, installing, or using the SecretMenu mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not use the App.
                        
                        These Terms apply to all users of the App, including without limitation users who are browsers, vendors, customers, merchants, and/or contributors of content.
                        """
                    )
                    
                    // App Description
                    TermsSection(
                        title: "2. Description of Service",
                        content: """
                        SecretMenu is a mobile application that allows users to:
                        • Save and organize custom food and drink orders
                        • Categorize orders by restaurant or café
                        • Use tags to organize orders across different places
                        • Display saved orders in a clean format for ordering
                        • Export order data (Premium feature)
                        
                        The App operates locally on your device and does not require an internet connection for core functionality.
                        """
                    )
                    
                    // User Accounts
                    TermsSection(
                        title: "3. User Accounts and Data",
                        content: """
                        **Local Storage**: All data created in SecretMenu is stored locally on your device. We do not collect, store, or access your personal information.
                        
                        **Data Ownership**: You retain full ownership of all data you create within the App.
                        
                        **Data Responsibility**: You are responsible for:
                        • Backing up your data
                        • Maintaining the security of your device
                        • Ensuring compliance with applicable laws when using the App
                        """
                    )
                    
                    // Premium Features
                    TermsSection(
                        title: "4. Premium Features and Payments",
                        content: """
                        **Premium Subscription**: SecretMenu offers premium features through one-time in-app purchases.
                        
                        **Payment Processing**: All payments are processed by Apple through the App Store. We do not store or process payment information.
                        
                        **Refunds**: Refund requests must be submitted through Apple's App Store refund process.
                        
                        **Feature Availability**: Premium features are subject to change. We will provide reasonable notice of any material changes.
                        """
                    )
                    
                    // Acceptable Use
                    TermsSection(
                        title: "5. Acceptable Use",
                        content: """
                        You agree to use the App only for lawful purposes and in accordance with these Terms. You agree not to:
                        
                        • Use the App for any illegal or unauthorized purpose
                        • Violate any applicable laws or regulations
                        • Infringe upon the rights of others
                        • Attempt to reverse engineer or modify the App
                        • Use the App to store or transmit harmful content
                        • Interfere with the proper functioning of the App
                        """
                    )
                    
                    // Intellectual Property
                    TermsSection(
                        title: "6. Intellectual Property",
                        content: """
                        **App Ownership**: The App and its original content, features, and functionality are owned by SecretMenu and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.
                        
                        **User Content**: You retain ownership of any content you create within the App. By using the App, you grant us a limited license to process your data solely for the purpose of providing the App's functionality.
                        
                        **Trademarks**: SecretMenu and related trademarks are the property of SecretMenu.
                        """
                    )
                    
                    // Privacy
                    TermsSection(
                        title: "7. Privacy",
                        content: """
                        Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information. By using the App, you agree to the collection and use of information in accordance with our Privacy Policy.
                        
                        The Privacy Policy is incorporated into these Terms by reference.
                        """
                    )
                    
                    // Disclaimers
                    TermsSection(
                        title: "8. Disclaimers",
                        content: """
                        **As-Is Service**: The App is provided "as is" and "as available" without any warranties of any kind.
                        
                        **No Guarantees**: We do not guarantee that the App will be error-free, secure, or uninterrupted.
                        
                        **Third-Party Services**: The App may integrate with third-party services (e.g., Apple services). We are not responsible for the availability or content of these services.
                        
                        **Data Loss**: We are not responsible for any loss of data that may occur during normal use of the App.
                        """
                    )
                    
                    // Limitation of Liability
                    TermsSection(
                        title: "9. Limitation of Liability",
                        content: """
                        To the maximum extent permitted by law, SecretMenu shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.
                        
                        Our total liability to you for any claims arising from the use of the App shall not exceed the amount you paid for the App.
                        """
                    )
                    
                    // Termination
                    TermsSection(
                        title: "10. Termination",
                        content: """
                        **Your Rights**: You may stop using the App at any time by uninstalling it from your device.
                        
                        **Our Rights**: We may terminate or suspend access to the App immediately, without prior notice, for any reason, including breach of these Terms.
                        
                        **Effect of Termination**: Upon termination, your right to use the App will cease immediately.
                        """
                    )
                    
                    // Changes to Terms
                    TermsSection(
                        title: "11. Changes to Terms",
                        content: """
                        We reserve the right to modify these Terms at any time. We will notify users of any material changes by:
                        • Updating the "Last updated" date
                        • Posting the new Terms in the App
                        
                        Your continued use of the App after any changes constitutes acceptance of the new Terms.
                        """
                    )
                    
                    // Governing Law
                    TermsSection(
                        title: "12. Governing Law",
                        content: """
                        These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which SecretMenu operates, without regard to its conflict of law provisions.
                        
                        Any disputes arising from these Terms or the use of the App shall be resolved in the courts of competent jurisdiction.
                        """
                    )
                    
                    // Contact Information
                    TermsSection(
                        title: "13. Contact Information",
                        content: """
                        If you have any questions about these Terms of Service, please contact us:
                        
                        **Email**: secretmenu.contact@gmail.com
                        **App**: Through the Settings > About section
                        
                        We will respond to your inquiry within a reasonable timeframe.
                        """
                    )
                    
                    // Legal Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Legal Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("These Terms of Service constitute the entire agreement between you and SecretMenu regarding the use of the App. If any provision of these Terms is found to be unenforceable, the remaining provisions will continue to be valid and enforceable.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Terms of Service")
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

struct TermsSection: View {
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
    TermsView()
} 