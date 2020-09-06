//
//  NewsFeedViewCell.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: NewsFeedViewCellViewModel!
    
    func fill(model: NewsFeedViewCellViewModel){
        self.viewModel = model
        setUp()
    }
    override func awakeFromNib() {
//        self.drinkName.font = UIFont.robotoFont19
//        self.drinkName.textColor = UIColor.defaultTextColor
    }
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
       // publishDateLabel.text = ""
    }
    
    private func setUp(){
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        //self.publishDateLabel.text = viewModel.publishDate
    }
}
