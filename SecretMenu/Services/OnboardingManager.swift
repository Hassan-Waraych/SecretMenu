import Foundation
import SwiftUI

@MainActor
class OnboardingManager: ObservableObject {
    static let shared = OnboardingManager()
    
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var hasCompletedTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedTutorial, forKey: "hasCompletedTutorial")
        }
    }
    
    @Published var currentTutorialStep: TutorialStep = .none
    @Published var isShowingTutorial: Bool = false
    
    private init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.hasCompletedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
    }
    
    func startOnboarding() {
        hasCompletedOnboarding = false
        hasCompletedTutorial = false
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func startTutorial() {
        isShowingTutorial = true
        currentTutorialStep = .addPlace
    }
    
    func completeTutorial() {
        hasCompletedTutorial = true
        isShowingTutorial = false
        currentTutorialStep = .none
    }
    
    func nextTutorialStep() {
        switch currentTutorialStep {
        case .addPlace:
            currentTutorialStep = .addOrder
        case .addOrder:
            currentTutorialStep = .addTag
        case .addTag:
            currentTutorialStep = .complete
        case .complete, .none:
            completeTutorial()
        }
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        hasCompletedTutorial = false
        currentTutorialStep = .none
        isShowingTutorial = false
    }
}

enum TutorialStep: CaseIterable {
    case addPlace
    case addOrder
    case addTag
    case complete
    case none
    
    var title: String {
        switch self {
        case .addPlace:
            return "Add Your First Place"
        case .addOrder:
            return "Create an Order"
        case .addTag:
            return "Organize with Tags"
        case .complete:
            return "You're All Set!"
        case .none:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .addPlace:
            return "Start by adding a restaurant or café where you love to order from"
        case .addOrder:
            return "Create your first custom order with all your favorite modifications"
        case .addTag:
            return "Create tags to organize your orders across different places"
        case .complete:
            return "You've mastered the basics! Start exploring your SecretMenu"
        case .none:
            return ""
        }
    }
    
    var icon: String {
        switch self {
        case .addPlace:
            return "building.2.fill"
        case .addOrder:
            return "list.bullet.clipboard.fill"
        case .addTag:
            return "tag.fill"
        case .complete:
            return "checkmark.circle.fill"
        case .none:
            return ""
        }
    }
} 