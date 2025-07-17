//
//  PopularPlaces.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation

struct PopularPlace {
    let name: String
    let iconName: String // SF Symbol name
    let keywords: [String]
}

struct PopularPlaces {
    static let places: [PopularPlace] = [
        PopularPlace(name: "Starbucks", iconName: "cup.and.saucer.fill", keywords: ["coffee", "latte", "frappuccino", "espresso", "cafe", "drink", "beverage"]),
        PopularPlace(name: "Chipotle", iconName: "tortilla", keywords: ["burrito", "bowl", "mexican", "guac", "chipotle"]),
        PopularPlace(name: "Dunkin'", iconName: "cup.and.saucer.fill", keywords: ["coffee", "donut", "doughnut", "latte", "espresso", "drink", "beverage"]),
        PopularPlace(name: "McDonald's", iconName: "flame.fill", keywords: ["burger", "fries", "fast food", "mcdonalds", "big mac"]),
        PopularPlace(name: "Subway", iconName: "leaf.fill", keywords: ["sandwich", "sub", "healthy", "fresh"]),
        PopularPlace(name: "Taco Bell", iconName: "tortilla", keywords: ["taco", "burrito", "mexican", "fast food"]),
        PopularPlace(name: "Tim Hortons", iconName: "cup.and.saucer.fill", keywords: ["coffee", "donut", "latte", "espresso", "canada"]),
        PopularPlace(name: "Chick-fil-A", iconName: "bird.fill", keywords: ["chicken", "sandwich", "nuggets", "fast food"]),
        PopularPlace(name: "Burger King", iconName: "flame.fill", keywords: ["burger", "fries", "fast food", "whopper"]),
        PopularPlace(name: "Wendy's", iconName: "flame.fill", keywords: ["burger", "fries", "fast food"]),
        PopularPlace(name: "Panera", iconName: "cup.and.saucer.fill", keywords: ["bakery", "cafe", "sandwich", "soup", "bread"]),
        // ...add more as needed
    ]
    
    static func search(query: String) -> [PopularPlace] {
        let q = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return Array(places.prefix(10)) }
        return places.filter { place in
            place.name.lowercased().contains(q) || place.keywords.contains(where: { $0.contains(q) })
        }
    }
    
    static func getPlaceByName(_ name: String) -> PopularPlace? {
        return places.first { $0.name.lowercased() == name.lowercased() }
    }
} 