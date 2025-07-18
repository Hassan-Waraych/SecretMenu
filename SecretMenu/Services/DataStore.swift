//
//  DataStore.swift
//  SecretMenu
//
//  Created by Hassan Waraych on 2025-07-16.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class DataStore: ObservableObject {
    static let shared = DataStore()
    
    private let container: NSPersistentContainer
    private let premiumManager = PremiumManager.shared
    
    private init() {
        container = NSPersistentContainer(name: "SecretMenu")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Place Operations
    
    func createPlace(name: String) -> PlaceCreationResult {
        do {
            // Check if place already exists
            let existingPlaces = try fetchPlaces()
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if existingPlaces.contains(where: { $0.name?.lowercased() == trimmedName.lowercased() }) {
                return .alreadyExists
            }
            
            // Check total place limit (3ces total for free users)
            if !premiumManager.canAddUnlimitedPlaces {
                let totalPlacesCount = try getTotalPlacesCount()
                if totalPlacesCount >= premiumManager.freePlaceLimit {
                    return .limitReached
                }
            }
            
            let place = Place(context: viewContext)
            place.id = UUID()
            place.name = trimmedName
            place.createdAt = Date()
            
            try viewContext.save()
            return .success(place)
        } catch {
            return .error(error)
        }
    }
    
    func fetchPlaces() throws -> [Place] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Place.name, ascending: true)]
        return try viewContext.fetch(request)
    }
    
    func deletePlace(_ place: Place) throws {
        viewContext.delete(place)
        try viewContext.save()
    }
    
    func getTotalPlacesCount() throws -> Int {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        return try viewContext.count(for: request)
    }
    
    func getCustomPlacesCount() throws -> Int {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        let popularPlaceNames = Set(PopularPlaces.places.map { $0.name })
        request.predicate = NSPredicate(format: "NOT (name IN %@)", popularPlaceNames)
        return try viewContext.count(for: request)
    }
    
    // MARK: - Order Operations
    
    func createOrder(title: String, details: String, place: Place, tags: [String] = [], photoPath: String? = nil) -> OrderCreationResult {
        do {
            // Check free limit for orders
            if !premiumManager.canAddUnlimitedOrders {
                let orderCount = try getOrderCount()
                if orderCount >= premiumManager.totalOrderLimit {
                    return .limitReached
                }
            }
            
            let order = Order(context: viewContext)
            order.id = UUID()
            order.title = title
            order.details = details
            order.place = place
            order.tags = tags
            order.photoPath = photoPath
            order.createdAt = Date()
            
            try viewContext.save()
            return .success(order)
        } catch {
            return .error(error)
        }
    }
    
    func fetchOrders(for place: Place? = nil) throws -> [Order] {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        
        if let place = place {
            request.predicate = NSPredicate(format: "place == %@", place)
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    func fetchOrders(withTags tags: [String]) throws -> [Order] {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags IN %@", tags)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)]
        return try viewContext.fetch(request)
    }
    
    func updateOrder(_ order: Order, title: String, details: String, tags: [String], photoPath: String?) throws {
        order.title = title
        order.details = details
        order.tags = tags
        order.photoPath = photoPath
        
        try viewContext.save()
    }
    
    func deleteOrder(_ order: Order) throws {
        viewContext.delete(order)
        try viewContext.save()
    }
    
    func getOrderCount() throws -> Int {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        return try viewContext.count(for: request)
    }
    
    // MARK: - Tag Operations
    
    func createTag(name: String, color: String? = nil) throws -> Tag {
        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = name
        tag.color = color
        tag.createdAt = Date()
        
        try viewContext.save()
        return tag
    }
    
    func fetchTags() throws -> [Tag] {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]
        return try viewContext.fetch(request)
    }
    
    func updateTag(_ tag: Tag, name: String, color: String?) throws {
        tag.name = name
        tag.color = color
        
        try viewContext.save()
    }
    
    func deleteTag(_ tag: Tag) throws {
        viewContext.delete(tag)
        try viewContext.save()
    }
    
    // MARK: - Utility Methods
    
    func save() throws {
        try viewContext.save()
    }
    
    func rollback() {
        viewContext.rollback()
    }
}

// MARK: - DataStore Errors

enum DataStoreError: LocalizedError {
    case orderLimitReached
    case placeLimitReached
    case placeAlreadyExists
    case saveFailed
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .orderLimitReached:
            return "You've reached the free order limit. Upgrade to Premium for unlimited orders."
        case .placeLimitReached:
            return "You've reached the free place limit (3laces). Upgrade to Premium for unlimited places."
        case .placeAlreadyExists:
            return "A place with this name already exists."
        case .saveFailed:
            return "Failed to save data. Please try again."
        case .fetchFailed:
            return "Failed to load data. Please try again."
        }
    }
}

// MARK: - Custom Result Types for Paywall Triggers

enum PlaceCreationResult {
    case success(Place)
    case limitReached
    case alreadyExists
    case error(Error)
}

enum OrderCreationResult {
    case success(Order)
    case limitReached
    case error(Error)
} 