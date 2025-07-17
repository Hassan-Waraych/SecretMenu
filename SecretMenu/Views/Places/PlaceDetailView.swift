//
//  PlaceDetailView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

@MainActor
class PlaceOrdersManager: ObservableObject {
    @Published var orders: [Order] = []
    private let place: Place
    
    init(place: Place) {
        self.place = place
        loadOrders()
    }
    
    func loadOrders() {
        do {
            orders = try DataStore.shared.fetchOrders(for: place)
            print("Loaded \(orders.count) orders for \(place.name ?? "unknown place")")
        } catch {
            print("Failed to load orders: \(error)")
        }
    }
    
    func refresh() {
        loadOrders()
    }
}

struct PlaceDetailView: View {
    let place: Place
    @EnvironmentObject private var adManager: AdManager
    @StateObject private var ordersManager: PlaceOrdersManager
    
    @State private var showingAddOrder = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateIn = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var orderAnimationOffset: CGFloat = 50
    
    init(place: Place) {
        self.place = place
        self._ordersManager = StateObject(wrappedValue: PlaceOrdersManager(place: place))
    }
    
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
                if ordersManager.orders.isEmpty {
                    emptyStateView
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 30)
                } else {
                    ordersList
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : orderAnimationOffset)
                }
                
                // Banner ad at bottom
                if adManager.shouldShowAds() && adManager.isBannerAdLoaded {
                    BannerAdView()
                        .frame(height: 50)
                }
            }
        }
        .navigationTitle(place.name ?? "Place")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddOrder = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .scaleEffect(buttonScale)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                buttonScale = 0.8
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    buttonScale = 1.0
                                }
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showingAddOrder, onDismiss: {
            // Force refresh of orders when sheet is dismissed
            print("Sheet dismissed, refreshing orders...")
            ordersManager.refresh()
        }) {
            AddOrderView(place: place)
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                orderAnimationOffset = 0
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated place icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                if let popularPlace = PopularPlaces.getPlaceByName(place.name ?? ""),
                   let brandImageName = popularPlace.brandImageName {
                    Image(brandImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateIn)
                } else {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateIn)
                }
            }
            
            VStack(spacing: 16) {
                Text("No Orders Yet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Add your first custom order for \(place.name ?? "this place")")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddOrder = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("Add Your First Order")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                .scaleEffect(animateIn ? 1 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateIn)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var ordersList: some View {
        VStack(spacing: 20) {
            // Add Order button at top
            Button(action: { showingAddOrder = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("Add New Order")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(buttonScale)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    buttonScale = 0.95
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        buttonScale = 1.0
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
                                      // Orders container
             List {
                 ForEach(Array(ordersManager.orders.enumerated()), id: \.element.id) { index, order in
                     NavigationLink(destination: OrderDetailView(order: order)) {
                         OrderRowView(order: order)
                     }
                     .listRowBackground(Color.clear)
                     .listRowSeparator(.hidden)
                     .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                     .opacity(animateIn ? 1 : 0)
                     .offset(y: animateIn ? 0 : 30)
                     .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateIn)
                 }
                 .onDelete(perform: deleteOrders)
             }
             .listStyle(PlainListStyle())
             .background(
                 RoundedRectangle(cornerRadius: 20)
                     .fill(Color(.systemBackground))
                     .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 8)
             )
             .padding(.horizontal, 20)
        }
        .onAppear {
            print("OrdersList appeared with \(ordersManager.orders.count) orders")
        }
        .onChange(of: ordersManager.orders.count) { count in
            print("Orders count changed to: \(count)")
        }
    }
    
    private func deleteOrders(offsets: IndexSet) {
        let ordersToDelete = offsets.map { ordersManager.orders[$0] }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Remove from local array immediately for instant UI feedback
            for index in offsets.sorted(by: >) {
                ordersManager.orders.remove(at: index)
            }
        }
        
        // Delete from Core Data
        for order in ordersToDelete {
            do {
                try DataStore.shared.deleteOrder(order)
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                // If deletion failed, refresh to restore the original state
                ordersManager.refresh()
                break
            }
        }
    }
}

struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 16) {
            // Order icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "doc.text.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Order details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(order.title ?? "Untitled Order")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Tags
                    if let tags = order.tags, !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(tags.prefix(2), id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                        .foregroundColor(.white)
                                }
                                
                                if tags.count > 2 {
                                    Text("+\(tags.count - 2)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(.systemGray4))
                                        )
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                if let details = order.details, !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Photo indicator
                if let photoPath = order.photoPath, !photoPath.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "photo.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Has photo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
                         // Chevron
             Image(systemName: "chevron.right")
                 .font(.caption)
                 .foregroundColor(.secondary)
                 .opacity(0.6)
         }
    }
}

#Preview {
    NavigationView {
        PlaceDetailView(place: Place())
    }
    .environment(\.managedObjectContext, DataStore.shared.viewContext)
    .environmentObject(AdManager.shared)
} 