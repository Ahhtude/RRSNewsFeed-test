//
//  NewsDetailViewModel.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import AlamofireImage

class NewsDetailViewModel {
    private let model: RSSNewsFeed?
    //private let newsImage: UIImage?
    
    init(newsFeed model: RSSNewsFeed) {
        self.model = model
    }
    
    
}
