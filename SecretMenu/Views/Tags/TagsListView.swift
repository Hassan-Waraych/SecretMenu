//
//  TagsListView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct TagsListView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "tag")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Tags Coming Soon")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This feature will be implemented in Phase 5")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Tags")
        }
    }
}

#Preview {
    TagsListView()
} 