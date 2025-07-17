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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var adManager: AdManager
    
    @State private var showingEditOrder = false
    @State private var showingDeleteAlert = false
    @State private var showingBaristaMode = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateIn = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var photoScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header section
                    headerSection
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : -50)
                    
                    // Order details section
                    detailsSection
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 30)
                    
                    // Tags section
                    if let tags = order.tags, !tags.isEmpty {
                        tagsSection(tags: tags)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 40)
                    }
                    
                    // Photo section
                    if let photoPath = order.photoPath, !photoPath.isEmpty {
                        photoSection(photoPath: photoPath)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 50)
                            .scaleEffect(animateIn ? 1 : 0.8)
                    }
                    
                    // Action buttons
                    actionButtonsSection
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 60)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle(order.title ?? "Order")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit") {
                        showingEditOrder = true
                    }
                    
                    Button("Show to Barista") {
                        showingBaristaMode = true
                    }
                    
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
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
        .sheet(isPresented: $showingEditOrder) {
            EditOrderView(order: order)
        }
        .fullScreenCover(isPresented: $showingBaristaMode) {
            BaristaModeView(order: order)
        }
        .alert("Delete Order", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteOrder()
            }
        } message: {
            Text("Are you sure you want to delete this order? This action cannot be undone.")
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
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Place icon with animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                if let placeName = order.place?.name,
                   let popularPlace = PopularPlaces.getPlaceByName(placeName),
                   let brandImageName = popularPlace.brandImageName {
                    Image(brandImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateIn)
                } else {
                    Image(systemName: "building.2.fill")
                        .font(.title)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateIn)
                }
            }
            
            VStack(spacing: 8) {
                if let placeName = order.place?.name {
                    Text(placeName)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                
                Text(order.title ?? "Untitled Order")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Customization Details", icon: "doc.text.fill")
            
            if let details = order.details, !details.isEmpty {
                Text(details)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            } else {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.orange)
                    Text("No details provided")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private func tagsSection(tags: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Tags", icon: "tag.fill")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    HStack(spacing: 6) {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Text(tag)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private func photoSection(photoPath: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Photo", icon: "photo.fill")
            
            if let image = loadImageFromPath(photoPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(16)
                    .scaleEffect(photoScale)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            photoScale = photoScale == 1.0 ? 1.05 : 1.0
                        }
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            } else {
                HStack {
                    Image(systemName: "photo.slash")
                        .foregroundColor(.gray)
                    Text("Photo not found")
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Show to Barista button
            Button(action: { showingBaristaMode = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "display")
                        .font(.title2)
                    Text("Show to Barista")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
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
            
            // Edit Order button
            Button(action: { showingEditOrder = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.title2)
                    Text("Edit Order")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
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
        }
        .padding(.horizontal, 20)
    }
    
    private func loadImageFromPath(_ path: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(path)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    private func deleteOrder() {
        do {
            try DataStore.shared.deleteOrder(order)
            withAnimation(.easeInOut(duration: 0.3)) {
                dismiss()
            }
        } catch {
            errorMessage = "Failed to delete order: \(error.localizedDescription)"
            showingError = true
        }
    }
}

struct BaristaModeView: View {
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateIn = false
    @State private var photoScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(colorScheme == .dark ? .black : .white)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Place name
                    if let placeName = order.place?.name {
                        Text(placeName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : -20)
                    }
                    
                    // Order title
                    Text(order.title ?? "Untitled Order")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : -30)
                        .scaleEffect(animateIn ? 1 : 0.8)
                    
                    // Order details
                    if let details = order.details, !details.isEmpty {
                        Text(details)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                            .lineSpacing(8)
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 20)
                    }
                    
                    // Photo if exists
                    if let photoPath = order.photoPath, !photoPath.isEmpty,
                       let image = loadImageFromPath(photoPath) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(20)
                            .scaleEffect(photoScale)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    photoScale = photoScale == 1.0 ? 1.1 : 1.0
                                }
                            }
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                    }
                    
                    // Tags
                    if let tags = order.tags, !tags.isEmpty {
                        VStack(spacing: 16) {
                            Text("Tags:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .opacity(animateIn ? 1 : 0)
                                .offset(y: animateIn ? 0 : 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                            )
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                        }
                    }
                    
                    Spacer()
                    
                    // Instructions
                    Text("Show this screen to the barista/cashier")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 20)
                }
            }
            .navigationTitle("Barista Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dismiss()
                        }
                    }
                    .fontWeight(.medium)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    animateIn = true
                }
            }
        }
    }
    
    private func loadImageFromPath(_ path: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(path)
        return UIImage(contentsOfFile: fileURL.path)
    }
}

struct EditOrderView: View {
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var premiumManager: PremiumManager
    
    @State private var title: String
    @State private var details: String
    @State private var selectedTags: Set<String>
    @State private var availableTags: [Tag] = []
    @State private var newTagName = ""
    @State private var showingTagInput = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateIn = false
    
    init(order: Order) {
        self.order = order
        self._title = State(initialValue: order.title ?? "")
        self._details = State(initialValue: order.details ?? "")
        self._selectedTags = State(initialValue: Set(order.tags ?? []))
    }
    
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Order details section
                        orderDetailsSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                        
                        // Tags section
                        tagsSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 40)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dismiss()
                        }
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveOrder()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(canSave ? .blue : .gray)
                    .disabled(!canSave)
                    .scaleEffect(canSave ? 1 : 0.9)
                    .animation(.easeInOut(duration: 0.2), value: canSave)
                }
            }
            .onAppear {
                loadTags()
                withAnimation(.easeOut(duration: 0.6)) {
                    animateIn = true
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert("Add New Tag", isPresented: $showingTagInput) {
                TextField("Tag Name", text: $newTagName)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addNewTag()
                }
            }
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Order Details", icon: "doc.text.fill")
            
            VStack(spacing: 16) {
                // Title field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Order Title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Order Title", text: $title)
                        .textFieldStyle(ModernTextFieldStyle())
                }
                
                // Details field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customization Details")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Customization Details", text: $details, axis: .vertical)
                        .textFieldStyle(ModernTextFieldStyle())
                        .lineLimit(3...6)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Tags", icon: "tag.fill")
            
            VStack(spacing: 12) {
                if !availableTags.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(availableTags) { tag in
                            TagChip(
                                tag: tag,
                                isSelected: selectedTags.contains(tag.name ?? ""),
                                onTap: { toggleTag(tag) }
                            )
                            .scaleEffect(selectedTags.contains(tag.name ?? "") ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTags.contains(tag.name ?? ""))
                        }
                    }
                }
                
                Button(action: { showingTagInput = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Tag")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private func loadTags() {
        do {
            availableTags = try DataStore.shared.fetchTags()
        } catch {
            errorMessage = "Failed to load tags: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func toggleTag(_ tag: Tag) {
        guard let tagName = tag.name else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedTags.contains(tagName) {
                selectedTags.remove(tagName)
            } else {
                selectedTags.insert(tagName)
            }
        }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        do {
            let newTag = try DataStore.shared.createTag(name: trimmedName)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                availableTags.append(newTag)
                selectedTags.insert(trimmedName)
            }
            newTagName = ""
        } catch {
            errorMessage = "Failed to create tag: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func saveOrder() {
        do {
            try DataStore.shared.updateOrder(
                order,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                details: details.trimmingCharacters(in: .whitespacesAndNewlines),
                tags: Array(selectedTags),
                photoPath: order.photoPath
            )
            withAnimation(.easeInOut(duration: 0.3)) {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

#Preview {
    NavigationView {
        OrderDetailView(order: Order())
    }
    .environment(\.managedObjectContext, DataStore.shared.viewContext)
    .environmentObject(AdManager.shared)
} 