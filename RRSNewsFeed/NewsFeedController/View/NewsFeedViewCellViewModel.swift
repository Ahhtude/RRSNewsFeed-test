//
//  NewsFeedViewCellViewModel.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation

class NewsFeedViewCellViewModel {
    var model: RSSNewsFeed
    
    init(model: RSSNewsFeed) {
        self.model = model
    }
    
    var title : String {
        return model.title
    }
    
    var description : String {
        return model.description
    }

    var publishDate : String {
        return model.pubData
    }
}

