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
}

class CoreDataManager {
    static func addData(post: RSSNewsFeed) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RssSavedModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try? Constants.context.fetch(request)
            
            guard let data = result as? [RssSavedModel]
        
                else {
                    print("adding news to core data failed")
                    return
            }
            
                    let news = NSManagedObject(entity: Constants.entity!, insertInto: Constants.context)
                    news.setValue(post.title, forKey: "title")
                    news.setValue(post.description, forKey: "descr")
                    news.setValue(post.moreData, forKey: "moreData")
                    news.setValue(post.mediaDataURL, forKey: "mediaData")
//                    if let imgString = post.image {
//                        news.setValue(imgString, forKey: "image")
//                    }
                    try Constants.context.save()
        }
        catch {
                    print("Failed saving")
                }
    }
}