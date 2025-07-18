import SwiftUI

struct TutorialOverlayView: View {
    @StateObject private var onboardingManager = OnboardingManager.shared
    @State private var showPulse = false
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    // Allow tapping through to dismiss
                }
            
            // Tutorial content
            VStack(spacing: 0) {
                Spacer()
                
                tutorialContent
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
            }
        }
        .onAppear {
            startPulseAnimation()
        }
    }
    
    @ViewBuilder
    private var tutorialContent: some View {
        switch onboardingManager.currentTutorialStep {
        case .addPlace:
            tutorialCard(
                title: "Add Your First Place",
                description: "Tap the + button to add a restaurant or café",
                icon: "building.2.fill",
                gradientColors: [.blue, .purple]
            )
        case .addOrder:
            tutorialCard(
                title: "Create an Order",
                description: "Tap on a place to add your first custom order",
                icon: "list.bullet.clipboard.fill",
                gradientColors: [.orange, .red]
            )
        case .addTag:
            tutorialCard(
                title: "Organize with Tags",
                description: "Go to Tags tab and create your first tag",
                icon: "tag.fill",
                gradientColors: [.green, .teal]
            )
        case .complete:
            completionCard
        case .none:
            EmptyView()
        }
    }
    
    private func tutorialCard(title: String, description: String, icon: String, gradientColors: [Color]) -> some View {
        VStack(spacing: 24) {
            // Icon with pulse animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.1) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 35))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Pulse ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(showPulse ? 1.5 : 1.0)
                    .opacity(showPulse ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: showPulse)
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            // Action buttons
            HStack(spacing: 16) {
                Button("Skip Tutorial") {
                    onboardingManager.completeTutorial()
                }
                .foregroundColor(.white.opacity(0.7))
                .font(.headline)
                
                Spacer()
                
                Button("Got it!") {
                    onboardingManager.nextTutorialStep()
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: gradientColors[0].opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6).opacity(0.9))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private var completionCard: some View {
        VStack(spacing: 24) {
            // Success icon with animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.1), .teal.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: showCheckmark ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 35))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(showCheckmark ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCheckmark)
            }
            
            VStack(spacing: 12) {
                Text("You're All Set!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("You've mastered the basics of SecretMenu. Start exploring and create your perfect collection of custom orders!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            Button("Start Exploring") {
                onboardingManager.completeTutorial()
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.green, .teal],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6).opacity(0.9))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.green, .teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showCheckmark = true
            }
        }
    }
    
    private func startPulseAnimation() {
        showPulse = true
    }
}

// Tutorial highlight overlay for specific UI elements
struct TutorialHighlightView: View {
    let targetFrame: CGRect
    let cornerRadius: CGFloat
    let gradientColors: [Color]
    
    var body: some View {
        ZStack {
            // Cutout mask
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .mask(
                    Rectangle()
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .frame(
                                    width: targetFrame.width,
                                    height: targetFrame.height
                                )
                                .position(
                                    x: targetFrame.midX,
                                    y: targetFrame.midY
                                )
                                .blendMode(.destinationOut)
                        )
                )
            
            // Highlight border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(
                    width: targetFrame.width,
                    height: targetFrame.height
                )
                .position(
                    x: targetFrame.midX,
                    y: targetFrame.midY
                )
        }
    }
}

#Preview {
    TutorialOverlayView()
} 