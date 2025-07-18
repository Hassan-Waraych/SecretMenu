//
//  AdUnlockView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct AdUnlockView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var adManager: AdManager
    @EnvironmentObject private var premiumManager: PremiumManager
    
    @State private var animateIn = false
    @State private var giftScale: CGFloat = 0.5
    @State private var giftBounce: CGFloat = 0
    @State private var showSparkles = false
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var showingUpgradeView = false
    @State private var showNotification = false
    @State private var arrowPulse = false
    
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
                
                VStack(spacing: 0) {
                    // Animated gift icon
                    ZStack {
                        // Sparkles effect
                        if showSparkles {
                            ForEach(0..<8) { index in
                                Image(systemName: "sparkle")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                                    .offset(
                                        x: CGFloat(cos(Double(index) * .pi / 4)) * 60,
                                        y: CGFloat(sin(Double(index) * .pi / 4)) * 60
                                    )
                                    .opacity(showSparkles ? 1 : 0)
                                    .scaleEffect(showSparkles ? 1.5 : 0.5)
                                    .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.1), value: showSparkles)
                            }
                        }
                        
                        // Main gift icon
                        Image(systemName: "gift.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(giftScale)
                            .offset(y: giftBounce)
                            .shadow(color: .orange.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    .onAppear {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                            giftScale = 1.0
                        }
                        
                        // Gentle bouncing animation
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            giftBounce = -10
                        }
                    }
                    .padding(.top, 40)
                    
                    // Title and description
                    VStack(spacing: 16) {
                        Text("Unlock More Orders!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                        
                        Text("Watch a short ad to unlock +1 order slot and continue building your secret menu collection!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 40)
                    }
                    .padding(.top, 30)
                    
                    // Creative limit upgrade visualization
                    VStack(spacing: 25) {
                        // Current limit
                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("\(premiumManager.totalOrderLimit)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.blue)
                                
                                Text("Current")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            
                            // Arrow with animation
                            VStack(spacing: 0) {
                                ZStack {
                                    Color.clear.frame(height: 36) // Reserve space for arrow
                                    Image(systemName: "arrow.right")
                                        .font(.title)
                                        .foregroundColor(arrowPulse ? Color.yellow : Color.orange)
                                        .shadow(color: arrowPulse ? Color.yellow.opacity(0.5) : Color.orange.opacity(0.2), radius: arrowPulse ? 12 : 4, x: 0, y: 0)
                                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: arrowPulse)
                                }
                                .frame(height: 36)
                                Text("+1")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                    .padding(.top, 4)
                            }
                            
                            // New limit
                            VStack(spacing: 8) {
                                Text("\(premiumManager.totalOrderLimit + 1)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.green)
                                
                                Text("After Ad")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 280)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 50)
                    
                    Spacer()
                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        // Watch Ad button
                        Button(action: {
                            watchAd()
                        }) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                } else if showSuccess {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                } else {
                                    Image(systemName: "play.circle.fill")
                                        .font(.title2)
                                }
                                
                                Text(buttonText)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: buttonGradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(!adManager.canShowRewardedAd() || isLoading)
                        .scaleEffect(adManager.canShowRewardedAd() ? 1.0 : 0.95)
                        .opacity(adManager.canShowRewardedAd() ? 1.0 : 0.7)
                        
                        // Upgrade to Premium button
                        Button(action: {
                            showingUpgradeView = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.title3)
                                Text("Upgrade to Premium")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(.systemGray4), lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 60)
                    
                    Spacer()
                }
            }
            .navigationTitle("Daily Gift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingUpgradeView) {
                UpgradeView()
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    animateIn = true
                }
                arrowPulse = true
            }
        }
    }
    
    private var buttonText: String {
        if showSuccess {
            return "Success! +1 Slot Unlocked"
        } else if isLoading {
            return "Loading Ad..."
        } else if adManager.canShowRewardedAd() {
            return "Watch Ad to Unlock +1 Slot"
        } else {
            return "Ad Not Available"
        }
    }
    
    private var buttonGradientColors: [Color] {
        if showSuccess {
            return [.green, .mint]
        } else if adManager.canShowRewardedAd() {
            return [.blue, .purple]
        } else {
            return [.gray, .gray]
        }
    }
    
    private func watchAd() {
        guard adManager.canShowRewardedAd() else { return }
        
        isLoading = true
        
        adManager.showRewardedAd { success in
            isLoading = false
            
            if success {
                // Show success animation
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    showSuccess = true
                    giftScale = 1.3
                }
                
                // Show sparkles
                showSparkles = true
                
                // Dismiss immediately after success
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            } else {
                // Show error or retry
                withAnimation(.easeInOut(duration: 0.3)) {
                    giftScale = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        giftScale = 1.0
                    }
                }
            }
        }
    }
}

#Preview {
    AdUnlockView()
        .environmentObject(AdManager.shared)
        .environmentObject(PremiumManager.shared)
} 