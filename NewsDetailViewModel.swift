//
//  NewsDetailViewModel.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class NewsDetailViewModel {
    private(set) var model: RSSNewsFeed?
    private(set) var image: UIImage?
    
    init(newsFeed model: RSSNewsFeed) {
        self.model = model
    }
    
    func getImageFromUrlURL() -> URL? {
        return URL(string: model!.mediaDataURL)
    }
}
