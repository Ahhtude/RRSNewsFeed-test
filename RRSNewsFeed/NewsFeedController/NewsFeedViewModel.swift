//
//  NewsFeedViewModel.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation

fileprivate struct Constats {
    static let baseURl =  "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml"
}

class NewsFeedViewModel {
    private let newsParser = NewsFeedParser()
    private(set) var rssItems: [RSSNewsFeed] = []
    
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
    
    private func fetchData(){
        let newsParser = NewsFeedParser()
        newsParser.parseNewsFeed(url: Constats.baseURl) {[unowned self] (rssItem) in
            self.rssItems = rssItem
            print("ITEMS IS RSS \(rssItem)")
        }
    }
}
