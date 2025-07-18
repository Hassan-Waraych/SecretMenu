//
//  ThemeManager.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation
import SwiftUI

@MainActor
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .light
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedAppTheme"
    
    private init() {
        loadTheme()
    }
    
    // MARK: - Theme Management
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        saveTheme()
    }
    
    func getColorScheme() -> ColorScheme? {
        switch currentTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTheme() {
        if let themeString = userDefaults.string(forKey: themeKey),
           let theme = AppTheme(rawValue: themeString) {
            currentTheme = theme
        } else {
            // Default to light theme for free users
            currentTheme = .light
        }
    }
    
    private func saveTheme() {
        userDefaults.set(currentTheme.rawValue, forKey: themeKey)
    }
}

// MARK: - App Theme Enum

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }
    
    var description: String {
        switch self {
        case .system: return "Follows your device's appearance setting"
        case .light: return "Always use light appearance"
        case .dark: return "Always use dark appearance"
        }
    }
} 