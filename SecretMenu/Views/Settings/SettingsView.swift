//
//  SettingsView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Settings Coming Soon")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This feature will be implemented in Phase 6")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
} 