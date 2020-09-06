//
//  Core.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import CoreData

public final class Core {
    static let shared = Core()
    var container: NSPersistentContainer!
    private init() {
        container = NSPersistentContainer(name: "RRSNewsFeed")
        container.loadPersistentStores { storeDescription, error in
            if let error = error { print("Error loading... \(error)") }
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do { try container.viewContext.save()
            } catch { print("Error saving... \(error)") }
        }
    }
}
