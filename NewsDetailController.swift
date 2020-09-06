//
//  NewsDetailController.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 06.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation
import AlamofireImage

class NewsDetailController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var urlTextView: UITextView!
    
    var viewModel: NewsDetailViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel!.model!.title
        self.descriptionLabel.text = viewModel!.model!.description
        setUpImage()
    }
    
    private func setUpImage(){
        if let url = viewModel?.getImageFromUrlURL(), !url.absoluteString.isEmpty {
            self.image.af_setImage(withURL: url)
        } else {
            self.image.isHidden = true
        }
    }
}
