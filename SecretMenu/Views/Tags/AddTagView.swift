//
//  AddTagView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import SwiftUI

struct AddTagView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var premiumManager: PremiumManager
    
    @State private var tagName = ""
    @State private var selectedColor: Color = .blue
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isEditing = false
    @State private var existingTag: Tag?
    
    // Predefined colors for tags
    private let availableColors: [Color] = [
        .blue, .purple, .green, .orange, .red, .pink, .indigo, .teal, .brown, .mint
    ]
    
    init(tag: Tag? = nil) {
        self._existingTag = State(initialValue: tag)
        self._isEditing = State(initialValue: tag != nil)
        
        if let tag = tag {
            self._tagName = State(initialValue: tag.name ?? "")
            if let colorString = tag.color {
                self._selectedColor = State(initialValue: Color(hex: colorString) ?? .blue)
            }
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
                
                VStack(spacing: 24) {
                    // Tag Icon Preview
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [selectedColor.opacity(0.1), selectedColor.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "tag.fill")
                                .font(.title)
                                .foregroundColor(selectedColor)
                        }
                        .scaleEffect(1.2)
                        
                        Text("Tag Preview")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Tag Name Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tag Name")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        TextField("Enter tag name...", text: $tagName)
                            .textFieldStyle(.plain)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                    }
                    .padding(.horizontal, 20)
                    
                    // Color Selection (Premium Feature)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Tag Color")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if !premiumManager.isPremiumUser {
                                Image(systemName: "crown.fill")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Text("Premium")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        if premiumManager.isPremiumUser {
                            // Color grid for premium users
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                                ForEach(availableColors, id: \.self) { color in
                                    Button(action: { selectedColor = color }) {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                            )
                                            .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedColor)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            // Single color for free users
                            HStack {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 3)
                                    )
                                
                                Text("Default Blue (Upgrade to Premium for custom colors)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle(isEditing ? "Edit Tag" : "New Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Create") {
                        saveTag()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .disabled(tagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveTag() {
        let trimmedName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        do {
            if isEditing, let existingTag = existingTag {
                // Update existing tag
                let colorString = premiumManager.isPremiumUser ? selectedColor.toHex() : nil
                try DataStore.shared.updateTag(existingTag, name: trimmedName, color: colorString)
            } else {
                // Create new tag
                let colorString = premiumManager.isPremiumUser ? selectedColor.toHex() : nil
                _ = try DataStore.shared.createTag(name: trimmedName, color: colorString)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

// Helper extension for Color to hex string
extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

#Preview {
    AddTagView()
        .environmentObject(PremiumManager.shared)
} 