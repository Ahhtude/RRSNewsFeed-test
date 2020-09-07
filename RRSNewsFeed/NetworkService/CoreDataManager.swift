//
//  CoreDataManager.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import UIKit
import CoreData

fileprivate struct Constants {
    static let app = UIApplication.shared.delegate as! AppDelegate
    static let context = app.persistentContainer.viewContext
    static let entity = NSEntityDescription.entity(forEntityName: "RssSavedModel", in: context)
    static let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RssSavedModel")
}

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    static func addData(post: RSSNewsFeed) {
        let request = Constants.request
        request.returnsObjectsAsFaults = false
        do {
            let result = try? Constants.context.fetch(request)
            
            guard let data = result as? [RssSavedModel],!data.map({$0.title}).contains(post.title)
                else {
                    //print("adding news to core data failed")
                    return
            }
            
                    let news = NSManagedObject(entity: Constants.entity!, insertInto: Constants.context)
                    news.setValue(post.title, forKey: "title")
                    news.setValue(post.description, forKey: "descr")
                    news.setValue(post.moreData, forKey: "moreData")
                    news.setValue(post.mediaDataURL, forKey: "mediaData")
                    try Constants.context.save()
        }
        catch {
                    print("Failed saving")
                }
    }
    
    static func deleteData(object toDelete: RSSNewsFeed) {
       if let result = try? Constants.context.fetch(Constants.request) {
        let element = result.map({(element) -> RssSavedModel in
            return element as! RssSavedModel
            }).filter({$0.title == toDelete.title})
        Constants.context.delete(element[0])
        }
        
    }
    
    func getAllNews() -> [RssSavedModel] {
        var pp: [RssSavedModel] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "RssSavedModel")
            let f = try Core.shared.container.viewContext.fetch(r)
            pp = f as! [RssSavedModel]
            print("CoreData data count is \(pp.count)")
            return pp
        } catch let error as NSError {
            print("WAS ERROR in GET ALL NEWS \(error)")
            return []
        }
    }
}
