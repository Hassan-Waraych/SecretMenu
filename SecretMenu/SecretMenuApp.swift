//
//  SecretMenuApp.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

@main
struct SecretMenuApp: App {
    @StateObject private var dataStore = DataStore.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var onboardingManager = OnboardingManager.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingManager.hasCompletedOnboarding {
                    MainTabView()
                        .environment(\.managedObjectContext, dataStore.viewContext)
                        .preferredColorScheme(themeManager.getColorScheme())
                        .overlay(
                            Group {
                                if onboardingManager.isShowingTutorial {
                                    TutorialOverlayView()
                                }
                            }
                        )
                } else {
                    OnboardingView()
                }
            }
        }
    }
}
