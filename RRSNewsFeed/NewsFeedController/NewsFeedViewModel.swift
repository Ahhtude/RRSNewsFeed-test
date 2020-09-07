//
//  NewsFeedViewModel.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import CoreData

fileprivate struct Constats {
    static let baseURl =  "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml"
}

class NewsFeedViewModel {
    var rssItems: [RSSNewsFeed] = []
    
    //var didError: ((Error) -> Void)?
    var didUpdate: ((NewsFeedViewModel) -> Void)?
    
    private(set) var isUpdating: Bool = false {
        didSet { self.didUpdate?(self) }
    }
    
    func reloadData() {
        self.rssItems = []
        self.isUpdating = true
        fetchData()
    }
    
    private func fetchData() {
        let array = CoreDataManager.shared.getAllNews()
        array.forEach { item in
            self.rssItems.append(RSSNewsFeed(title: item.title!,
                                             description: item.descr!,
                                             mediaDataURL: item.mediaData!,
                                             moreData: item.moreData!))
        }
        self.isUpdating = false
        }
    
    func addNewNewsSource(url: String) {
        NewsFeedParser.instance.parseNewsFeed(url: url) { (rssItem) in
                    rssItem.forEach { item in
                        CoreDataManager.addData(post: item)
                    }
                }
        self.reloadData()
    }
    func deleteNewsFromData(index: Int) {
        CoreDataManager.deleteData(object: self.rssItems[index])
        self.rssItems.remove(at: index)
    }
}
