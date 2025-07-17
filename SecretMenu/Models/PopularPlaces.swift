//
//  PopularPlaces.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation

struct PopularPlace {
    let name: String
    let brandImageName: String? // Brand Image Name
    let keywords: [String]
    
    var hasBrandImage: Bool {
        return brandImageName != nil
    }
}

struct PopularPlaces {
    static let places: [PopularPlace] = [
        PopularPlace(name: "Starbucks", brandImageName: "starbucks", keywords: ["coffee", "latte", "frappuccino", "espresso", "cafe", "drink", "beverage"]),
        PopularPlace(name: "Chipotle", brandImageName: "chipotle", keywords: ["burrito", "bowl", "mexican", "guac", "chipotle"]),
        PopularPlace(name: "Dunkin'", brandImageName:  "dunkin", keywords: ["coffee", "donut", "doughnut", "latte", "espresso", "drink", "beverage"]),
        PopularPlace(name: "McDonald's", brandImageName: "mcdonalds", keywords: ["burger", "fries", "fast food", "mcdonalds", "big mac"]),
        PopularPlace(name: "Subway", brandImageName: "subway", keywords: ["sandwich", "sub", "healthy", "fresh"]),
        PopularPlace(name: "Taco Bell", brandImageName: "tacobell", keywords: ["taco", "burrito", "mexican", "fast food"]),
        PopularPlace(name: "Tim Hortons", brandImageName: "timhortons", keywords: ["coffee", "donut", "latte", "espresso", "canada"]),
        PopularPlace(name: "Chick-fil-A", brandImageName: "chickfila", keywords: ["chicken", "sandwich", "nuggets", "fast food"]),
        PopularPlace(name: "Burger King", brandImageName: "burgerking", keywords: ["burger", "fries", "fast food", "whopper"]),
        PopularPlace(name: "Wendy's", brandImageName: "wendys", keywords: ["burger", "fries", "fast food"]),
        PopularPlace(name: "Panera", brandImageName: "panera", keywords: ["bakery", "cafe", "sandwich", "soup", "bread"]),
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