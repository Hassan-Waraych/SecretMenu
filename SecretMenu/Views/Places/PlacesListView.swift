//
//  PlacesListView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-7.
//

import SwiftUI
import CoreData

struct PlacesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var premiumManager: PremiumManager
    @StateObject private var onboardingManager = OnboardingManager.shared
    // TODO: Re-enable when ad integration is fixed
    // @EnvironmentObject private var adManager: AdManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.name, ascending: true)],
        animation: .default)
    private var places: FetchedResults<Place>
    
    @State private var showingAddPlace = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var selectedPlace: Place?
    @State private var isRefreshing = false
    @State private var placeToDelete: Place?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if places.isEmpty {
                        emptyStateView
                    } else {
                        placesGrid
                    }
                    
                    // TODO: Re-enable when ad integration is fixed
                    // Banner ad at bottom
                    // if adManager.shouldShowAds() && adManager.isBannerAdLoaded {
                    //     BannerAdView()
                    //         .frame(height: 50)
                    // }
                }
            }
            .navigationTitle("Places")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPlace = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                            .scaleEffect(1.1)
                    }
                }
                

            }
            .sheet(isPresented: $showingAddPlace, onDismiss: {
                // Check if tutorial should advance
                if onboardingManager.currentTutorialStep == .addPlace && !places.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onboardingManager.nextTutorialStep()
                    }
                }
            }) {
                AddPlaceView()
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert("Delete Place", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deletePlace()
                }
            } message: {
                if let place = placeToDelete {
                    Text("Are you sure you want to delete '\(place.name ?? "Unknown Place")'? This will also delete all orders associated with this place.")
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated icon
            Image(systemName: "building.2.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
            
            VStack(spacing: 12) {
                Text("No Places Yet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Add your first restaurant or café to start saving custom orders")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddPlace = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Your First Place")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
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
            .scaleEffect(0.05)
            .animation(.easeInOut(duration: 0.2), value: UUID())
            
            Spacer()
        }
    }
    
    private var placesGrid: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(places) { place in
                    PlaceCardView(place: place) {
                        selectedPlace = place
                    } onDelete: {
                        placeToDelete = place
                        showingDeleteAlert = true
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .refreshable {
            await refreshPlacesAsync()
        }
        .background(
            NavigationLink(
                destination: Group {
                    if let place = selectedPlace {
                        PlaceDetailView(place: place)
                    }
                },
                isActive: Binding(
                    get: { selectedPlace != nil },
                    set: { if !$0 { selectedPlace = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    private func refreshPlaces() {
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isRefreshing = false
        }
    }
    
    private func refreshPlacesAsync() async {
        // Simulate refresh
        try? await Task.sleep(nanoseconds: 1000000000) // 1 second
    }
    
    private func deletePlace() {
        guard let place = placeToDelete else { return }
        
        do {
            try DataStore.shared.deletePlace(place)
            placeToDelete = nil
        } catch {
            errorMessage = "Failed to delete place: \(error.localizedDescription)"
            showingError = true
        }
    }
}

struct PlaceCardView: View {
    let place: Place
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    private var popularPlace: PopularPlace? {
        return PopularPlaces.getPlaceByName(place.name ?? "Unknown Place")
    }
    
    private var orderCount: Int {
        return place.orders?.count ?? 0
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                // Brand Icon or Default Icon
                if let popularPlace = popularPlace, let brandImageName = popularPlace.brandImageName {
                    // Use brand image
                    BrandIconView(place: popularPlace, size: 60)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                } else {
                    // Use default system symbol
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                VStack(spacing: 4) {
                    Text(place.name ?? "Unknown Place")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(orderCount)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(orderCount == 1 ? "order" : "orders")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: isPressed ? .clear : .black.opacity(0.1),
                        radius: isPressed ? 0 : 8,
                        x: 0,
                        y: isPressed ? 0 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .contextMenu {
            Button("Delete Place", role: .destructive) {
                onDelete()
            }
        }
    }
}

#Preview {
    PlacesListView()
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
        .environmentObject(PremiumManager.shared)
        // TODO: Re-enable when ad integration is fixed
        // .environmentObject(AdManager.shared)
} 