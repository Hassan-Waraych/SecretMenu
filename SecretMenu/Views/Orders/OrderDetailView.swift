//
//  OrderDetailView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

struct OrderDetailView: View {
    let order: Order
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Order Detail Coming Soon")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("This feature will be implemented in Phase 4")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                Text("Order: \(order.title ?? "Untitled")")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                if let placeName = order.place?.name {
                    Text("Place: \(placeName)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Order Detail")
    }
}

#Preview {
    NavigationView {
        OrderDetailView(order: Order())
    }
    .environment(\.managedObjectContext, DataStore.shared.viewContext)
} 