//
//  BrandIconView.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-7.
//

import SwiftUI

struct BrandIconView: View {
    let place: PopularPlace
    let size: CGFloat
    let useGradient: Bool
    
    init(place: PopularPlace, size: CGFloat = 50, useGradient: Bool = true) {
        self.place = place
        self.size = size
        self.useGradient = useGradient
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Brand Image
            if let brandImageName = place.brandImageName {
                Image(brandImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.85, height: size * 0.85)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BrandIconView(place: PopularPlaces.places[0], size: 60)
        BrandIconView(place: PopularPlaces.places[1], size: 60)
        BrandIconView(place: PopularPlaces.places[2], size: 60)
    }
    .padding()
} 