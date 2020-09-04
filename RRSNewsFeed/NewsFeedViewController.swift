//
//  NewsFeedViewController.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import UIKit

fileprivate struct Constats {
    static let baseURl =  "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml"
}

class NewsFeedViewController: UITableViewController {
    private var rssItems: [RSSNewsFeed]?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        print("LOL")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    private func fetchData(){
        let newsParser = NewsFeedParser()
        newsParser.parseNewsFeed(url: Constats.baseURl) {[unowned self] (rssItem) in
            self.rssItems = rssItem
            print("ITEMS IS RSS \(rssItem)")
            //self.tableView.reloadData()
            //self.tableview.reloadSection(IndexSet(integer:0), with: .left)
        }
    }
}

extension NewsFeedViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print("DATA IS LOAD \(self.rssItems![indexPath.item])")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
}

