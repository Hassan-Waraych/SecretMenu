//
//  AddOrderView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI
import CoreData
import PhotosUI

struct AddOrderView: View {
    let place: Place
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var premiumManager: PremiumManager
    
    @State private var title = ""
    @State private var details = ""
    @State private var selectedTags: Set<String> = []
    @State private var availableTags: [Tag] = []
    @State private var newTagName = ""
    @State private var showingTagInput = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var animateIn = false
    @State private var photoScale: CGFloat = 1.0
    @State private var tagAnimationOffset: CGFloat = 50
    
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
                .dismissKeyboardOnTap()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with place info
                        headerSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : -30)
                        
                        // Order details section
                        orderDetailsSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 30)
                        
                        // Tags section
                        tagsSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : tagAnimationOffset)
                        
                        // Photo section
                        photoSection
                            .opacity(animateIn ? 1 : 0)
                            .offset(y: animateIn ? 0 : 50)
                            .scaleEffect(animateIn ? 1 : 0.8)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Add Order")
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
                    .disabled(!canSave || isLoading)
                    .scaleEffect(canSave ? 1 : 0.9)
                    .animation(.easeInOut(duration: 0.2), value: canSave)
                }
            }
            .onAppear {
                loadTags()
                withAnimation(.easeOut(duration: 0.6)) {
                    animateIn = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                    tagAnimationOffset = 0
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
    
    private var headerSection: some View {
        VStack(spacing: 16) {
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
                
                if let popularPlace = PopularPlaces.getPlaceByName(place.name ?? ""),
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
            
            Text(place.name ?? "Unknown Place")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 20)
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
                    
                    TextField("e.g., Venti Iced Caramel Macchiato", text: $title)
                        .textFieldStyle(ModernTextFieldStyle())
                        .onChange(of: title) { _ in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                // Trigger save button animation
                            }
                        }
                }
                
                // Details field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customization Details")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g., Extra shot, light ice, caramel drizzle", text: $details, axis: .vertical)
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
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Photo (Optional)", icon: "photo.fill")
            
            if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                VStack(spacing: 12) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                        .scaleEffect(photoScale)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                photoScale = photoScale == 1.0 ? 1.05 : 1.0
                            }
                        }
                    
                    Button("Remove Photo") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.photoData = nil
                            self.selectedPhoto = nil
                        }
                    }
                    .foregroundColor(.red)
                    .fontWeight(.medium)
                }
            } else {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Text("Add Photo")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        
                        Text("Show your order to baristas")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
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
        .onChange(of: selectedPhoto) { _ in
            Task {
                await loadPhoto()
            }
        }
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
    
    private func loadPhoto() async {
        guard let selectedPhoto = selectedPhoto else { return }
        
        do {
            photoData = try await selectedPhoto.loadTransferable(type: Data.self)
            withAnimation(.easeInOut(duration: 0.3)) {
                // Photo loaded successfully
            }
        } catch {
            errorMessage = "Failed to load photo: \(error.localizedDescription)"
            showingError = true
        }
    }
    
    private func saveOrder() {
        isLoading = true
        
        // Save photo if exists
        var photoPath: String?
        if let photoData = photoData {
            photoPath = savePhotoToDocuments(photoData)
        }
        
        do {
            let _ = try DataStore.shared.createOrder(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                details: details.trimmingCharacters(in: .whitespacesAndNewlines),
                place: place,
                tags: Array(selectedTags),
                photoPath: photoPath
            )
            
            withAnimation(.easeInOut(duration: 0.3)) {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    private func savePhotoToDocuments(_ data: Data) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Failed to save photo: \(error)")
            return ""
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
    }
}

struct TagChip: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                Text(tag.name ?? "")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected ? 
                        LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [Color(.systemGray5), Color(.systemGray5)], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.clear : Color.blue.opacity(0.3),
                        lineWidth: isSelected ? 0 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddOrderView(place: Place())
        .environment(\.managedObjectContext, DataStore.shared.viewContext)
        .environmentObject(PremiumManager.shared)
} 