//
//  PlaceDetailView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

struct PlaceDetailView: View {
    let place: Place
    @EnvironmentObject private var adManager: AdManager
    
    @FetchRequest private var orders: FetchedResults<Order>
    
    @State private var showingAddOrder = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(place: Place) {
        self.place = place
        self._orders = FetchRequest(
            entity: Order.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)],
            predicate: NSPredicate(format: "place == %@", place),
            animation: .default
        )
    }
    
    var body: some View {
        VStack {
            if orders.isEmpty {
                emptyStateView
            } else {
                ordersList
            }
            
            // Banner ad at bottom
            if adManager.shouldShowAds() && adManager.isBannerAdLoaded {
                BannerAdView()
                    .frame(height: 50)
            }
        }
        .navigationTitle(place.name ?? "Place")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddOrder = true }) {
                    Label("Add Order", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddOrder) {
            AddOrderView(place: place)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Orders Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first custom order for \(place.name ?? "this place")")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Add Your First Order") {
                showingAddOrder = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var ordersList: some View {
        List {
            ForEach(orders) { order in
                NavigationLink(destination: OrderDetailView(order: order)) {
                    OrderRowView(order: order)
                }
            }
            .onDelete(perform: deleteOrders)
        }
    }
    
    private func deleteOrders(offsets: IndexSet) {
        withAnimation {
            offsets.map { orders[$0] }.forEach { order in
                do {
                    try DataStore.shared.deleteOrder(order)
                } catch {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
}

struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(order.title ?? "Untitled Order")
                    .font(.headline)
                
                Spacer()
                
                if let tags = order.tags, !tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            if let details = order.details, !details.isEmpty {
                Text(details)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if let photoPath = order.photoPath, !photoPath.isEmpty {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.blue)
                    Text("Has photo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let createdAt = order.createdAt {
                Text("Created \(createdAt, style: .relative) ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        PlaceDetailView(place: Place())
    }
    .environment(\.managedObjectContext, DataStore.shared.viewContext)
    .environmentObject(AdManager.shared)
} 