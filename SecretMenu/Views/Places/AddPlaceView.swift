//
//  AddPlaceView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-7.
//

import SwiftUI

struct AddPlaceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var premiumManager: PremiumManager
    
    @State private var searchText = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingUpgradeView = false
    
    private var filteredPlaces: [PopularPlace] {
        if searchText.isEmpty {
            return PopularPlaces.places
        } else {
            return PopularPlaces.search(query: searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .dismissKeyboardOnTap()
                
                VStack(spacing: 0) {
                    // Search Bar
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Search Popular Places")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            
                            TextField("Search places...", text: $searchText)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding()
                    
                    // Popular Places List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredPlaces, id: \.name) { place in
                                PopularPlaceRow(place: place) {
                                    addPlace(place.name)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Custom Place Section
                    if !searchText.isEmpty && !filteredPlaces.contains(where: { $0.name.lowercased() == searchText.lowercased() }) {
                        CustomPlaceSection(searchText: searchText) {
                            addPlace(searchText)
                        }
                    }
                }
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingUpgradeView) {
                UpgradeView()
            }
        }
    }
    
    private func addPlace(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let result = DataStore.shared.createPlace(name: trimmedName)
        
        switch result {
        case .success(_):
            dismiss()
        case .alreadyExists:
            // Silently ignore duplicate places - just dismiss
            dismiss()
        case .limitReached:
            // Show paywall instead of error
            showingUpgradeView = true
        case .error(let error):
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

struct PopularPlaceRow: View {
    let place: PopularPlace
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Brand Icon
                BrandIconView(place: place, size: 50)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .scaleEffect(isPressed ? 0.8 : 1)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: isPressed ? .clear : .black.opacity(0.05),
                        radius: isPressed ? 0 : 4,
                        x: 0,
                        y: isPressed ? 0 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct CustomPlaceSection: View {
    let searchText: String
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal)
            
            Button(action: onTap) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange.opacity(0.1), .red.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "building.2.fill")
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add Custom Place")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Add \"\(searchText)\" as a custom place")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("Add")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                        .scaleEffect(isPressed ? 0.9 : 1)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(
                            color: isPressed ? .clear : .black.opacity(0.05),
                            radius: isPressed ? 0 : 4,
                            x: 0,
                            y: isPressed ? 0 : 2
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddPlaceView()
        .environmentObject(PremiumManager.shared)
} 