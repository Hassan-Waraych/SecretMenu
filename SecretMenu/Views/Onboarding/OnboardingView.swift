import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingManager = OnboardingManager.shared
    @State private var currentPage = 0
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Welcome to SecretMenu",
            subtitle: "Your personal collection of custom orders",
            description: "Never forget your favorite modifications again. Save, organize, and share your secret menu items.",
            icon: "list.bullet.clipboard.fill",
            gradientColors: [.blue, .purple]
        ),
        OnboardingPage(
            title: "Organize by Places",
            subtitle: "Keep your orders organized",
            description: "Add your favorite restaurants and cafés. Each place gets its own collection of custom orders.",
            icon: "building.2.fill",
            gradientColors: [.orange, .red]
        ),
        OnboardingPage(
            title: "Tag Everything",
            subtitle: "Find orders instantly",
            description: "Create tags like 'Spicy', 'Vegetarian', or 'Quick' to organize and find your orders faster.",
            icon: "tag.fill",
            gradientColors: [.green, .teal]
        ),
        OnboardingPage(
            title: "Ready to Start?",
            subtitle: "Let's get you set up",
            description: "We'll walk you through creating your first place, order, and tag. It only takes a minute!",
            icon: "checkmark.circle.fill",
            gradientColors: [.purple, .pink]
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom controls
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        if currentPage < onboardingPages.count - 1 {
                            Button("Skip") {
                                onboardingManager.completeOnboarding()
                                onboardingManager.startTutorial()
                            }
                            .foregroundColor(.secondary)
                            .font(.headline)
                            
                            Spacer()
                            
                            Button("Next") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: onboardingPages[currentPage].gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: onboardingPages[currentPage].gradientColors[0].opacity(0.3), radius: 8, x: 0, y: 4)
                        } else {
                            Button("Get Started") {
                                onboardingManager.completeOnboarding()
                                onboardingManager.startTutorial()
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: onboardingPages[currentPage].gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: onboardingPages[currentPage].gradientColors[0].opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let gradientColors: [Color]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIn = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: page.gradientColors.map { $0.opacity(0.1) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: page.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animateIn ? 1.0 : 0.5)
            .opacity(animateIn ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateIn)
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            .opacity(animateIn ? 1.0 : 0.0)
            .offset(y: animateIn ? 0 : 30)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateIn)
            
            Spacer()
        }
        .onAppear {
            animateIn = true
        }
    }
}

#Preview {
    OnboardingView()
} 