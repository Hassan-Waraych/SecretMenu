//
//  AddOrderView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

struct AddOrderView: View {
    let place: Place
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Add Order Coming Soon")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This feature will be implemented in Phase 3")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("For: \(place.name ?? "Unknown Place")")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .navigationTitle("Add Order")
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

#Preview {
    AddOrderView(place: Place())
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
} 