//
//  TagsListView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData

@MainActor
class TagsManager: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var ordersByTag: [String: [Order]] = [:]
    
    func loadTags() {
        do {
            tags = try DataStore.shared.fetchTags()
            loadOrdersForTags()
        } catch {
            print("Failed to load tags: \(error)")
        }
    }
    
    func loadOrdersForTags() {
        do {
            let allOrders = try DataStore.shared.fetchOrders()
            ordersByTag.removeAll()
            
            for tag in tags {
                let tagName = tag.name ?? ""
                let ordersWithTag = allOrders.filter { order in
                    guard let orderTags = order.tags else { return false }
                    return orderTags.contains(tagName)
                }
                ordersByTag[tagName] = ordersWithTag
            }
        } catch {
            print("Failed to load orders for tags: \(error)")
        }
    }
    
    func refresh() {
        loadTags()
    }
}

struct TagsListView: View {
    @EnvironmentObject private var premiumManager: PremiumManager
    @EnvironmentObject private var adManager: AdManager
    @StateObject private var tagsManager = TagsManager()
    
    @State private var showingAddTag = false
    @State private var selectedTag: Tag?
    @State private var showingTagOrders = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if tagsManager.tags.isEmpty {
                        emptyStateView
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                    } else {
                        tagsList
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 50)
                    }
                    
                    // Banner ad at bottom
                    if adManager.shouldShowAds() && adManager.isBannerAdLoaded {
                        BannerAdView()
                            .frame(height: 50)
                    }
                }
            }
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTag = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                            .scaleEffect(1.1)
                    }
                }
            }
            .sheet(isPresented: $showingAddTag, onDismiss: {
                tagsManager.refresh()
            }) {
                AddTagView()
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                tagsManager.loadTags()
                withAnimation(.easeOut(duration: 0.8)) {
                    animateIn = true
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated tag icon
            Image(systemName: "tag.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(animateIn ? 1 : 0.5)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateIn)
            
            VStack(spacing: 16) {
                Text("No Tags Yet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Create tags to organize your orders across different places")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddTag = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("Create Your First Tag")
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
    }
    
    private var tagsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(tagsManager.tags.enumerated()), id: \.element.id) { index, tag in
                    TagCardView(
                        tag: tag,
                        orderCount: tagsManager.ordersByTag[tag.name ?? ""]?.count ?? 0
                    ) {
                        selectedTag = tag
                        showingTagOrders = true
                    } onDelete: {
                        deleteTag(tag)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateIn)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(
            NavigationLink(
                destination: Group {
                    if let tag = selectedTag {
                        TagOrdersView(tag: tag, orders: tagsManager.ordersByTag[tag.name ?? ""] ?? [])
                    }
                },
                isActive: Binding(
                    get: { showingTagOrders },
                    set: { if !$0 { selectedTag = nil; showingTagOrders = false } }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    private func deleteTag(_ tag: Tag) {
        do {
            try DataStore.shared.deleteTag(tag)
            tagsManager.refresh()
        } catch {
            errorMessage = "Failed to delete tag: \(error.localizedDescription)"
            showingError = true
        }
    }
}

struct TagCardView: View {
    let tag: Tag
    let orderCount: Int
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    @EnvironmentObject private var premiumManager: PremiumManager
    
    private var tagColor: Color {
        if premiumManager.isPremiumUser, let colorString = tag.color {
            return Color(hex: colorString) ?? .blue
        }
        return .blue
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Tag icon with color
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [tagColor.opacity(0.1), tagColor.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "tag.fill")
                        .font(.title3)
                        .foregroundColor(tagColor)
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tag.name ?? "Untitled Tag")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
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
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.6)
            }
            .padding(16)
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
                            colors: [tagColor.opacity(0.3), tagColor.opacity(0.5)],
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
            Button("Delete Tag", role: .destructive) {
                onDelete()
            }
        }
    }
}

struct TagOrdersView: View {
    let tag: Tag
    let orders: [Order]
    @EnvironmentObject private var adManager: AdManager
    
    @State private var animateIn = false
    
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
                if orders.isEmpty {
                    emptyStateView
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 30)
                } else {
                    ordersList
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 50)
                }
                
                // Banner ad at bottom
                if adManager.shouldShowAds() && adManager.isBannerAdLoaded {
                    BannerAdView()
                        .frame(height: 50)
                }
            }
        }
        .navigationTitle("\(tag.name ?? "Tag") Orders")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Tag icon
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
                
                Image(systemName: "tag.fill")
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
            
            VStack(spacing: 16) {
                Text("No Orders with This Tag")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Orders tagged with \"\(tag.name ?? "this tag")\" will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var ordersList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(orders.enumerated()), id: \.element.id) { index, order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRowView(order: order)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateIn)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

// Helper extension for Color from hex string
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TagsListView()
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
        .environmentObject(PremiumManager.shared)
        .environmentObject(AdManager.shared)
} 